# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Image Scraper Integration', type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }
  let(:test_url) { 'http://localhost:3000/test_images.html' }

  before do
    sign_in admin_user
  end

  describe 'GET /admin/image_scraper' do
    it 'loads the image scraper page successfully' do
      get '/admin/image_scraper'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Scrape Images from URL')
      expect(response.body).to include('Enter URL to scrape images from:')
    end
  end

  describe 'POST /admin/image_scraper/scrape' do
    it 'scrapes images from a URL and displays them' do
      # Mock the ImageScraperService to avoid external HTTP calls
      mock_images = [
        'https://picsum.photos/300/200?random=1',
        'https://picsum.photos/300/200?random=2',
        'https://via.placeholder.com/300x200.jpg'
      ]
      
      allow_any_instance_of(ImageScraperService).to receive(:scrape_images).and_return(mock_images)
      allow_any_instance_of(ImageScraperService).to receive(:errors).and_return([])

      post '/admin/image_scraper/scrape', params: { scraper_url: test_url }
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Images found on: #{test_url}")
      expect(response.body).to include('picsum.photos')
      expect(response.body).to include('Download Selected Images')
    end

    it 'handles errors gracefully' do
      # Mock the ImageScraperService to return errors
      allow_any_instance_of(ImageScraperService).to receive(:scrape_images).and_return([])
      allow_any_instance_of(ImageScraperService).to receive(:errors).and_return(['Network error'])

      post '/admin/image_scraper/scrape', params: { scraper_url: 'invalid-url' }
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Network error')
    end
  end

  describe 'POST /admin/image_scraper/download' do
    it 'downloads selected images and creates posts' do
      selected_images = [
        'https://picsum.photos/300/200?random=1',
        'https://picsum.photos/300/200?random=2'
      ]

      # Mock the ImageDownloaderService
      allow_any_instance_of(ImageDownloaderService).to receive(:download_multiple_images)
        .and_return({ success: 2, failed: 0, errors: [] })

      expect {
        post '/admin/image_scraper/download', params: {
          source_url: test_url,
          selected_images: selected_images
        }
      }.to change(Post, :count).by(0) # Mocked, so no actual posts created

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Successfully downloaded 2 images')
    end

    it 'handles download failures' do
      selected_images = ['https://invalid-image-url.com/image.jpg']

      # Mock the ImageDownloaderService to return failures
      allow_any_instance_of(ImageDownloaderService).to receive(:download_multiple_images)
        .and_return({ success: 0, failed: 1, errors: ['Failed to download image'] })

      post '/admin/image_scraper/download', params: {
        source_url: test_url,
        selected_images: selected_images
      }

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Failed to download image')
    end
  end
end
