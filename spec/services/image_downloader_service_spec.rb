# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageDownloaderService, type: :service do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }
  let(:image_url) { 'https://example.com/test-image.jpg' }
  let(:source_url) { 'https://example.com/source-page' }

  describe '#initialize' do
    it 'sets the user and initializes counters' do
      expect(service.instance_variable_get(:@user)).to eq(user)
      expect(service.errors).to be_empty
      expect(service.downloaded_count).to eq(0)
      expect(service.failed_count).to eq(0)
    end

    it 'uses first user if no user provided' do
      create(:user) # Ensure there's at least one user
      service_without_user = described_class.new
      expect(service_without_user.instance_variable_get(:@user)).to be_a(User)
    end
  end

  describe '#download_images' do
    let(:image_urls) { [image_url, 'https://example.com/image2.png'] }

    context 'with valid image URLs' do
      before do
        allow(service).to receive(:download_single_image).and_return(true)
      end

      it 'downloads all images successfully' do
        result = service.download_images(image_urls, source_url)
        
        expect(result).to be true
        expect(service.downloaded_count).to eq(2)
        expect(service.failed_count).to eq(0)
      end
    end

    context 'with some failing downloads' do
      before do
        allow(service).to receive(:download_single_image).and_return(true, false)
      end

      it 'tracks successful and failed downloads' do
        result = service.download_images(image_urls, source_url)
        
        expect(result).to be true # At least one succeeded
        expect(service.downloaded_count).to eq(1)
        expect(service.failed_count).to eq(1)
      end
    end

    context 'with empty image URLs' do
      it 'returns false for empty array' do
        result = service.download_images([], source_url)
        expect(result).to be false
      end

      it 'returns false for nil' do
        result = service.download_images(nil, source_url)
        expect(result).to be false
      end
    end
  end

  describe '#download_single_image' do
    let(:temp_file) { Tempfile.new(['test', '.jpg']) }
    let(:category) { create(:category, name: 'Scraped Images') }

    before do
      temp_file.write('fake image data')
      temp_file.rewind
      allow(service).to receive(:download_image_to_temp_file).and_return(temp_file)
      allow(service).to receive(:find_or_create_scraped_category).and_return(category)
    end

    after do
      temp_file.close
      temp_file.unlink
    end

    context 'with successful download and post creation' do
      it 'creates a post and returns true' do
        expect {
          result = service.download_single_image(image_url, source_url)
          expect(result).to be true
        }.to change(Post, :count).by(1)
        
        post = Post.last
        expect(post.title).to include('test-image')
        expect(post.text).to include(source_url)
        expect(post.user).to eq(user)
        expect(post.categories).to include(category)
      end
    end

    context 'when download fails' do
      before do
        allow(service).to receive(:download_image_to_temp_file).and_return(nil)
      end

      it 'returns false and does not create post' do
        expect {
          result = service.download_single_image(image_url, source_url)
          expect(result).to be false
        }.not_to change(Post, :count)
      end
    end

    context 'when post creation fails' do
      before do
        allow_any_instance_of(Post).to receive(:save!).and_raise(StandardError.new('Save failed'))
      end

      it 'handles errors gracefully' do
        result = service.download_single_image(image_url, source_url)
        expect(result).to be false
        expect(service.errors).to include(match(/Error downloading.*Save failed/))
      end
    end
  end

  describe 'private methods' do
    describe '#download_image_to_temp_file' do
      let(:fake_image_data) { "\xFF\xD8\xFF\xE0fake jpeg data" } # JPEG header + data

      before do
        allow(URI).to receive(:open).and_yield(StringIO.new(fake_image_data))
      end

      it 'downloads image and creates temp file' do
        temp_file = service.send(:download_image_to_temp_file, image_url)
        
        expect(temp_file).to be_a(Tempfile)
        expect(temp_file.size).to be > 0
        
        temp_file.close
        temp_file.unlink
      end

      context 'when download fails' do
        before do
          allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404 Not Found', StringIO.new))
        end

        it 'returns nil and adds error' do
          temp_file = service.send(:download_image_to_temp_file, image_url)
          
          expect(temp_file).to be_nil
          expect(service.errors).to include(match(/HTTP Error downloading.*404 Not Found/))
        end
      end

      context 'when downloaded file is empty' do
        before do
          allow(URI).to receive(:open).and_yield(StringIO.new(''))
        end

        it 'returns nil and adds error' do
          temp_file = service.send(:download_image_to_temp_file, image_url)
          
          expect(temp_file).to be_nil
          expect(service.errors).to include(match(/Downloaded file is empty/))
        end
      end
    end

    describe '#valid_image_file?' do
      it 'returns true for JPEG files' do
        temp_file = Tempfile.new(['test', '.jpg'])
        temp_file.write("\xFF\xD8\xFF\xE0")
        temp_file.rewind
        
        result = service.send(:valid_image_file?, temp_file)
        expect(result).to be true
        
        temp_file.close
        temp_file.unlink
      end

      it 'returns true for PNG files' do
        temp_file = Tempfile.new(['test', '.png'])
        temp_file.write("\x89PNG\r\n\x1A\n")
        temp_file.rewind
        
        result = service.send(:valid_image_file?, temp_file)
        expect(result).to be true
        
        temp_file.close
        temp_file.unlink
      end

      it 'returns false for non-image files' do
        temp_file = Tempfile.new(['test', '.txt'])
        temp_file.write("This is not an image")
        temp_file.rewind
        
        result = service.send(:valid_image_file?, temp_file)
        expect(result).to be false
        
        temp_file.close
        temp_file.unlink
      end
    end

    describe '#generate_title_from_url' do
      it 'generates title from filename' do
        url = 'https://example.com/beautiful-sunset.jpg'
        title = service.send(:generate_title_from_url, url)
        expect(title).to eq('Beautiful Sunset')
      end

      it 'handles URLs without filename' do
        url = 'https://example.com/'
        title = service.send(:generate_title_from_url, url)
        expect(title).to match(/Scraped Image \d{8}_\d{6}/)
      end

      it 'truncates long filenames' do
        long_filename = 'a' * 60
        url = "https://example.com/#{long_filename}.jpg"
        title = service.send(:generate_title_from_url, url)
        expect(title.length).to be <= 51  # Allow for "..." at the end
        expect(title).to end_with('...')
      end
    end

    describe '#find_or_create_scraped_category' do
      it 'finds existing scraped category' do
        existing_category = create(:category, name: 'Scraped Images')
        category = service.send(:find_or_create_scraped_category)
        expect(category).to eq(existing_category)
      end

      it 'creates new scraped category if not exists' do
        expect {
          category = service.send(:find_or_create_scraped_category)
          expect(category.name).to eq('Scraped Images')
          expect(category.user).to be_a(User)
        }.to change(Category, :count).by(1)
      end
    end
  end
end
