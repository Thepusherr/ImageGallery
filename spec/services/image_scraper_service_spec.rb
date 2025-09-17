# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageScraperService, type: :service do
  let(:valid_url) { 'https://example.com/page-with-images' }
  let(:invalid_url) { 'not-a-url' }
  let(:service) { described_class.new(valid_url) }

  describe '#initialize' do
    it 'sets the URL and initializes empty errors array' do
      expect(service.url).to eq(valid_url)
      expect(service.errors).to be_empty
    end
  end

  describe '#scrape_images' do
    context 'with invalid URL' do
      let(:service) { described_class.new(invalid_url) }

      it 'returns empty array and adds error' do
        result = service.scrape_images
        expect(result).to be_empty
        expect(service.errors).to include('Invalid URL format')
      end
    end

    context 'with valid URL' do
      let(:html_content) do
        <<~HTML
          <html>
            <body>
              <img src="/image1.jpg" alt="Image 1">
              <img src="https://example.com/image2.png" alt="Image 2">
              <img data-src="/lazy-image.gif" alt="Lazy Image">
              <div style="background-image: url('/bg-image.jpg')"></div>
              <img src="/not-an-image.txt">
            </body>
          </html>
        HTML
      end

      before do
        allow(URI).to receive(:open).and_return(StringIO.new(html_content))
      end

      it 'extracts image URLs from the page' do
        result = service.scrape_images
        
        expect(result).to include('https://example.com/image1.jpg')
        expect(result).to include('https://example.com/image2.png')
        expect(result).to include('https://example.com/lazy-image.gif')
        expect(result).to include('https://example.com/bg-image.jpg')
        expect(result).not_to include('https://example.com/not-an-image.txt')
      end

      it 'converts relative URLs to absolute URLs' do
        result = service.scrape_images
        
        expect(result).to all(start_with('https://'))
      end

      it 'removes duplicate URLs' do
        html_with_duplicates = <<~HTML
          <html>
            <body>
              <img src="/image1.jpg">
              <img src="/image1.jpg">
              <img src="https://example.com/image1.jpg">
            </body>
          </html>
        HTML
        
        allow(URI).to receive(:open).and_return(StringIO.new(html_with_duplicates))
        
        result = service.scrape_images
        expect(result.count('https://example.com/image1.jpg')).to eq(1)
      end
    end

    context 'when network error occurs' do
      before do
        allow(URI).to receive(:open).and_raise(SocketError.new('Network error'))
      end

      it 'handles network errors gracefully' do
        result = service.scrape_images
        expect(result).to be_empty
        expect(service.errors).to include('Network Error: Network error')
      end
    end

    context 'when HTTP error occurs' do
      before do
        allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404 Not Found', StringIO.new))
      end

      it 'handles HTTP errors gracefully' do
        result = service.scrape_images
        expect(result).to be_empty
        expect(service.errors).to include('HTTP Error: 404 Not Found')
      end
    end
  end

  describe '#scrape_images_with_details' do
    let(:html_content) do
      <<~HTML
        <html>
          <body>
            <img src="/image1.jpg" alt="Beautiful Image">
            <img src="/image2.png">
          </body>
        </html>
      HTML
    end

    before do
      allow(URI).to receive(:open).and_return(StringIO.new(html_content))
      allow(service).to receive(:estimate_image_size).and_return(1024)
    end

    it 'returns detailed information about images' do
      result = service.scrape_images_with_details
      
      expect(result).to be_an(Array)
      expect(result.first).to include(:url, :alt, :estimated_size, :valid)
      expect(result.first[:url]).to eq('https://example.com/image1.jpg')
      expect(result.first[:valid]).to be true
    end
  end

  describe 'private methods' do
    describe '#valid_url?' do
      it 'returns true for valid HTTP URLs' do
        service = described_class.new('http://example.com')
        expect(service.send(:valid_url?)).to be true
      end

      it 'returns true for valid HTTPS URLs' do
        service = described_class.new('https://example.com')
        expect(service.send(:valid_url?)).to be true
      end

      it 'returns false for invalid URLs' do
        service = described_class.new('not-a-url')
        expect(service.send(:valid_url?)).to be false
      end

      it 'returns false for non-HTTP protocols' do
        service = described_class.new('ftp://example.com')
        expect(service.send(:valid_url?)).to be false
      end
    end

    describe '#valid_image_url?' do
      it 'returns true for URLs with image extensions' do
        expect(service.send(:valid_image_url?, 'https://example.com/image.jpg')).to be true
        expect(service.send(:valid_image_url?, 'https://example.com/image.png')).to be true
        expect(service.send(:valid_image_url?, 'https://example.com/image.gif')).to be true
        expect(service.send(:valid_image_url?, 'https://example.com/image.webp')).to be true
      end

      it 'returns true for URLs containing image keywords' do
        expect(service.send(:valid_image_url?, 'https://example.com/image/123')).to be true
        expect(service.send(:valid_image_url?, 'https://example.com/img/photo')).to be true
        expect(service.send(:valid_image_url?, 'https://example.com/photo/gallery')).to be true
      end

      it 'returns false for non-image URLs' do
        expect(service.send(:valid_image_url?, 'https://example.com/document.pdf')).to be false
        expect(service.send(:valid_image_url?, 'https://example.com/video.mp4')).to be false
        expect(service.send(:valid_image_url?, 'https://example.com/page.html')).to be false
      end

      it 'returns false for nil or empty URLs' do
        expect(service.send(:valid_image_url?, nil)).to be false
        expect(service.send(:valid_image_url?, '')).to be false
      end
    end
  end
end
