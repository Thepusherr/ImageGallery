# frozen_string_literal: true

ActiveAdmin.register_page 'Image Scraper' do
  menu priority: 3, label: 'Image Scraper'

  content title: 'Scrape Images from URL' do
    # Add CSS styles
    style do
      raw <<~CSS
        .image-scraper-container {
          max-width: 1200px;
          margin: 0 auto;
        }

        .url-scraper-form {
          background: #f9f9f9;
          padding: 20px;
          border-radius: 8px;
          margin-bottom: 30px;
        }

        .form-group {
          margin-bottom: 15px;
        }

        .form-group label {
          display: block;
          margin-bottom: 5px;
          font-weight: bold;
        }

        .form-control {
          width: 100%;
          padding: 10px;
          border: 1px solid #ddd;
          border-radius: 4px;
          font-size: 14px;
        }

        .btn {
          padding: 10px 20px;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-size: 14px;
          text-decoration: none;
          display: inline-block;
        }

        .btn-primary {
          background-color: #007cba;
          color: white;
        }

        .btn-success {
          background-color: #28a745;
          color: white;
        }

        .images-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 20px;
          margin: 20px 0;
        }

        .image-item {
          border: 1px solid #ddd;
          border-radius: 8px;
          padding: 15px;
          background: white;
        }

        .image-preview {
          text-align: center;
          margin-bottom: 10px;
        }

        .image-info {
          font-size: 12px;
        }

        .image-info p {
          margin: 5px 0;
        }

        .image-actions {
          margin-top: 10px;
          padding-top: 10px;
          border-top: 1px solid #eee;
        }

        .form-actions {
          text-align: center;
          margin-top: 30px;
          padding: 20px;
          background: #f9f9f9;
          border-radius: 8px;
        }

        .alert {
          padding: 15px;
          margin: 20px 0;
          border-radius: 4px;
        }

        .alert-danger {
          background-color: #f8d7da;
          border: 1px solid #f5c6cb;
          color: #721c24;
        }

        .alert-info {
          background-color: #d1ecf1;
          border: 1px solid #bee5eb;
          color: #0c5460;
        }
      CSS
    end
    div class: 'image-scraper-container' do
      # Form for URL input
      form action: admin_image_scraper_scrape_path, method: :post, class: 'url-scraper-form' do
        input type: 'hidden', name: 'authenticity_token', value: form_authenticity_token

        div class: 'form-group' do
          label 'Enter URL to scrape images from:', for: 'scraper_url'
          input type: 'url',
                name: 'scraper_url',
                id: 'scraper_url',
                placeholder: 'https://example.com/page-with-images',
                value: params[:scraper_url],
                class: 'form-control',
                required: true
        end

        div class: 'form-group' do
          input type: 'submit', value: 'Scrape Images', class: 'btn btn-primary'
        end
      end

      # Display scraped images if URL was provided
      if params[:scraper_url].present?
        div class: 'scraped-images-section' do
          h3 "Images found on: #{params[:scraper_url]}"
          
          scraper = ImageScraperService.new(params[:scraper_url])
          images = scraper.scrape_images_with_details
          
          if scraper.errors.any?
            div class: 'alert alert-danger' do
              h4 'Errors occurred:'
              ul do
                scraper.errors.each do |error|
                  li error
                end
              end
            end
          end
          
          if images.any?
            form action: admin_image_scraper_download_path, method: :post, class: 'image-selection-form' do
              input type: 'hidden', name: 'authenticity_token', value: form_authenticity_token
              input type: 'hidden', name: 'source_url', value: params[:scraper_url]
              
              div class: 'images-grid' do
                images.each_with_index do |image_data, index|
                  div class: 'image-item' do
                    div class: 'image-preview' do
                      begin
                        img src: image_data[:url], 
                            alt: image_data[:alt] || 'Scraped image',
                            style: 'max-width: 200px; max-height: 200px; object-fit: cover;',
                            onerror: "this.style.display='none'; this.nextElementSibling.style.display='block';"
                        div style: 'display: none; padding: 20px; border: 1px dashed #ccc; text-align: center;' do
                          'Image failed to load'
                        end
                      rescue StandardError
                        div style: 'padding: 20px; border: 1px dashed #ccc; text-align: center;' do
                          'Invalid image URL'
                        end
                      end
                    end
                    
                    div class: 'image-info' do
                      p do
                        strong 'URL: '
                        span image_data[:url], style: 'word-break: break-all; font-size: 12px;'
                      end
                      
                      if image_data[:alt]
                        p do
                          strong 'Alt text: '
                          span image_data[:alt]
                        end
                      end
                      
                      if image_data[:estimated_size]
                        p do
                          strong 'Size: '
                          span "#{(image_data[:estimated_size] / 1024.0).round(1)} KB"
                        end
                      end
                      
                      div class: 'image-actions' do
                        label do
                          input type: 'checkbox', 
                                name: 'selected_images[]', 
                                value: image_data[:url],
                                checked: image_data[:valid]
                          ' Select for download'
                        end
                      end
                    end
                  end
                end
              end
              
              div class: 'form-actions' do
                input type: 'submit', value: 'Download Selected Images', class: 'btn btn-success'
              end
            end
          else
            div class: 'alert alert-info' do
              'No images found on this page.'
            end
          end
        end
      end
    end
  end

  # Handle URL scraping
  page_action :scrape, method: :post do
    redirect_to admin_image_scraper_path(scraper_url: params[:scraper_url])
  end

  # Handle image download
  page_action :download, method: :post do
    if params[:selected_images].present?
      begin
        # Use the ImageDownloaderService
        current_user = current_admin_user&.becomes(User) || User.first
        downloader = ImageDownloaderService.new(current_user)

        success = downloader.download_images(params[:selected_images], params[:source_url])

        if success
          message = "Successfully downloaded #{downloader.downloaded_count} images."
          message += " #{downloader.failed_count} failed." if downloader.failed_count > 0

          if downloader.errors.any?
            message += " Errors: #{downloader.errors.join(', ')}"
          end

          redirect_to admin_posts_path, notice: message
        else
          error_message = 'Failed to download any images.'
          error_message += " Errors: #{downloader.errors.join(', ')}" if downloader.errors.any?

          redirect_to admin_image_scraper_path(scraper_url: params[:source_url]),
                      alert: error_message
        end
      rescue StandardError => e
        Rails.logger.error "Image download error: #{e.message}"
        redirect_to admin_image_scraper_path(scraper_url: params[:source_url]),
                    alert: "Error: #{e.message}"
      end
    else
      redirect_to admin_image_scraper_path, alert: 'Please select at least one image.'
    end
  end
end
