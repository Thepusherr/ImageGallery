# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard Query', type: :model do
  describe 'dashboard images query' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }

    before do
      # Create posts with images
      3.times do |i|
        post = create(:post, user: user, title: "Test Post #{i}")
        post.categories << category

        # Create a test image file for CarrierWave
        file_path = Rails.root.join('spec/fixtures/test_image.jpg')
        FileUtils.mkdir_p(File.dirname(file_path)) unless File.directory?(File.dirname(file_path))

        unless File.exist?(file_path)
          File.open(file_path, 'wb') do |f|
            f.write('Test image content')
          end
        end

        # Set image using CarrierWave
        post.image = File.open(file_path)
        post.save!
      end
    end

    it 'returns posts with images ordered by creation date' do
      posts = Post.where.not(image: [nil, '']).order(created_at: :desc).limit(10)

      expect(posts.count).to eq(3)
      expect(posts.first.title).to eq('Test Post 2')
      expect(posts.first.image).to be_present
    end

    it 'includes all required data for dashboard display' do
      posts = Post.where.not(image: [nil, '']).order(created_at: :desc).limit(10)

      posts.each do |post|
        expect(post.title).to be_present
        expect(post.user).to be_present
        expect(post.image).to be_present
        expect(post.categories).to be_present
      end
    end
  end
end
