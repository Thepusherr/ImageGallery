# frozen_string_literal: true

require 'tempfile'
require 'open-uri'

# Service for downloading images from URLs and creating posts
class ImageDownloaderService
  attr_reader :errors, :downloaded_count, :failed_count

  def initialize(user = nil)
    @user = user || User.first
    @errors = []
    @downloaded_count = 0
    @failed_count = 0
  end

  # Download multiple images from URLs
  def download_images(image_urls, source_url = nil)
    return false if image_urls.blank?

    image_urls.each do |image_url|
      if download_single_image(image_url, source_url)
        @downloaded_count += 1
      else
        @failed_count += 1
      end
    end

    @downloaded_count > 0
  end

  # Download a single image and create a post
  def download_single_image(image_url, source_url = nil)
    begin
      temp_file = download_image_to_temp_file(image_url)
      return false unless temp_file

      post = create_post_from_temp_file(temp_file, image_url, source_url)
      
      # Clean up temp file
      temp_file.close
      temp_file.unlink

      if post&.persisted?
        Rails.logger.info "Successfully downloaded image: #{image_url}"
        true
      else
        @errors << "Failed to save post for image: #{image_url}"
        false
      end
    rescue StandardError => e
      @errors << "Error downloading #{image_url}: #{e.message}"
      Rails.logger.error "Error downloading image #{image_url}: #{e.message}"
      false
    end
  end

  private

  def download_image_to_temp_file(image_url)
    # Get file extension from URL
    uri = URI.parse(image_url)
    extension = File.extname(uri.path)
    extension = '.jpg' if extension.empty?
    
    # Create temporary file
    temp_file = Tempfile.new(['scraped_image', extension])
    temp_file.binmode
    
    # Download image with proper headers
    URI.open(image_url, 
             'User-Agent' => 'Mozilla/5.0 (compatible; ImageScraper/1.0)',
             'Accept' => 'image/*',
             read_timeout: 30) do |image|
      temp_file.write(image.read)
    end
    
    temp_file.rewind
    
    # Validate that we actually downloaded an image
    if temp_file.size == 0
      temp_file.close
      temp_file.unlink
      @errors << "Downloaded file is empty: #{image_url}"
      return nil
    end

    # Basic image validation
    unless valid_image_file?(temp_file)
      temp_file.close
      temp_file.unlink
      @errors << "Downloaded file is not a valid image: #{image_url}"
      return nil
    end

    temp_file
  rescue OpenURI::HTTPError => e
    @errors << "HTTP Error downloading #{image_url}: #{e.message}"
    temp_file&.close
    temp_file&.unlink
    nil
  rescue SocketError => e
    @errors << "Network Error downloading #{image_url}: #{e.message}"
    temp_file&.close
    temp_file&.unlink
    nil
  rescue StandardError => e
    @errors << "Error downloading #{image_url}: #{e.message}"
    temp_file&.close
    temp_file&.unlink
    nil
  end

  def valid_image_file?(temp_file)
    # Read first few bytes to check for image magic numbers
    temp_file.rewind
    header = temp_file.read(12)
    temp_file.rewind
    
    return false if header.nil? || header.empty?

    # Check for common image file signatures
    # JPEG: FF D8 FF
    # PNG: 89 50 4E 47
    # GIF: 47 49 46 38
    # WebP: 52 49 46 46 (RIFF) + WebP
    # BMP: 42 4D
    
    header_hex = header.unpack('H*')[0].upcase
    
    header_hex.start_with?('FFD8FF') ||      # JPEG
    header_hex.start_with?('89504E47') ||    # PNG
    header_hex.start_with?('47494638') ||    # GIF
    header_hex.start_with?('424D') ||        # BMP
    (header_hex.start_with?('52494646') && header.include?('WEBP')) # WebP
  end

  def create_post_from_temp_file(temp_file, image_url, source_url)
    # Generate title from URL
    title = generate_title_from_url(image_url)
    
    # Create text content
    text = if source_url
             "Image scraped from #{source_url}"
           else
             "Downloaded from #{image_url}"
           end

    # Find or create category for scraped images
    category = find_or_create_scraped_category

    # Create the post
    post = Post.new(
      title: title,
      text: text,
      user: @user
    )

    # Associate with category
    post.categories << category

    # Attach the image using CarrierWave
    post.image = temp_file
    
    if post.save
      Rails.logger.info "Created post with ID: #{post.id} for image: #{image_url}"
      post
    else
      @errors << "Failed to save post: #{post.errors.full_messages.join(', ')}"
      Rails.logger.error "Failed to save post: #{post.errors.full_messages.join(', ')}"
      nil
    end
  rescue StandardError => e
    @errors << "Error creating post: #{e.message}"
    Rails.logger.error "Error creating post from temp file: #{e.message}"
    nil
  end

  def generate_title_from_url(image_url)
    uri = URI.parse(image_url)
    filename = File.basename(uri.path, '.*')
    
    if filename.empty? || filename == '/'
      "Scraped Image #{Time.current.strftime('%Y%m%d_%H%M%S')}"
    else
      # Clean up filename and make it human readable
      cleaned = filename.gsub(/[_-]/, ' ').titleize
      cleaned.length > 50 ? "#{cleaned[0..47]}..." : cleaned
    end
  rescue StandardError
    "Scraped Image #{Time.current.strftime('%Y%m%d_%H%M%S')}"
  end

  def find_or_create_scraped_category
    # Find existing category or create new one
    existing_category = Category.joins(:user).find_by(name: 'Scraped Images')
    return existing_category if existing_category

    # Create new category with first user
    user = User.first
    return nil unless user

    Category.create!(name: 'Scraped Images', user: user)
  rescue StandardError => e
    Rails.logger.error "Error finding/creating scraped category: #{e.message}"
    # Fallback to first available category
    Category.first || Category.create!(name: 'General', user: User.first)
  end
end
