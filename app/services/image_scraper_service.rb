# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'uri'

# Service for scraping images from web pages
class ImageScraperService
  attr_reader :url, :errors

  def initialize(url)
    @url = url
    @errors = []
  end

  # Main method to scrape images from the URL
  def scrape_images
    return [] unless valid_url?

    begin
      @last_document = fetch_document
      return [] unless @last_document

      extract_image_urls(@last_document)
    rescue StandardError => e
      @errors << "Error scraping images: #{e.message}"
      []
    end
  end

  # Get detailed image information including dimensions and file size
  def scrape_images_with_details
    image_urls = scrape_images
    return [] if image_urls.empty?

    image_urls.map do |img_url|
      {
        url: img_url,
        alt: extract_alt_text(img_url),
        estimated_size: estimate_image_size(img_url),
        valid: valid_image_url?(img_url)
      }
    end
  end

  private

  def valid_url?
    uri = URI.parse(@url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    @errors << 'Invalid URL format'
    false
  end

  def fetch_document
    URI.open(@url, 'User-Agent' => 'Mozilla/5.0 (compatible; ImageScraper/1.0)') do |page|
      Nokogiri::HTML(page)
    end
  rescue OpenURI::HTTPError => e
    @errors << "HTTP Error: #{e.message}"
    nil
  rescue SocketError => e
    @errors << "Network Error: #{e.message}"
    nil
  rescue StandardError => e
    @errors << "Error fetching page: #{e.message}"
    nil
  end

  def extract_image_urls(doc)
    base_uri = URI.parse(@url)
    
    # Find all img tags
    img_tags = doc.css('img')
    
    image_urls = img_tags.map do |img|
      src = img['src'] || img['data-src'] || img['data-lazy-src']
      next unless src

      # Convert relative URLs to absolute URLs
      begin
        absolute_url = URI.join(base_uri, src).to_s
        absolute_url if valid_image_url?(absolute_url)
      rescue URI::InvalidURIError
        nil
      end
    end.compact.uniq

    # Also look for images in CSS background-image properties
    css_images = extract_css_background_images(doc, base_uri)
    
    (image_urls + css_images).uniq
  end

  def extract_css_background_images(doc, base_uri)
    css_images = []
    
    # Look for inline styles with background-image
    doc.css('[style*="background-image"]').each do |element|
      style = element['style']
      matches = style.scan(/background-image:\s*url\(['"]?([^'"]+)['"]?\)/)
      
      matches.each do |match|
        url = match[0]
        begin
          absolute_url = URI.join(base_uri, url).to_s
          css_images << absolute_url if valid_image_url?(absolute_url)
        rescue URI::InvalidURIError
          next
        end
      end
    end
    
    css_images
  end

  def valid_image_url?(url)
    return false unless url

    # Check if URL has image extension
    uri = URI.parse(url)
    path = uri.path.downcase
    
    image_extensions = %w[.jpg .jpeg .png .gif .bmp .webp .svg .tiff .ico]
    image_extensions.any? { |ext| path.end_with?(ext) } ||
      path.include?('image') ||
      url.include?('img') ||
      url.include?('photo')
  rescue URI::InvalidURIError
    false
  end

  def extract_alt_text(img_url)
    return nil unless @last_document

    img_tag = @last_document.css("img[src='#{img_url}']").first
    img_tag&.[]('alt') || File.basename(img_url, '.*').humanize
  end

  def estimate_image_size(img_url)
    begin
      URI.open(img_url, 'User-Agent' => 'Mozilla/5.0 (compatible; ImageScraper/1.0)') do |file|
        file.size
      end
    rescue StandardError
      nil
    end
  end
end
