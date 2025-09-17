FactoryBot.define do
  factory :post do
    title { 'Test Post' }
    text { 'Test Content' }
    user
    
    # Create a simple test image for CarrierWave
    after(:build) do |post|
      file_path = Rails.root.join('spec/fixtures/test_image.jpg')

      # Create the directory if it doesn't exist
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.directory?(File.dirname(file_path))

      # Create a simple test image if it doesn't exist
      unless File.exist?(file_path)
        File.open(file_path, 'wb') do |f|
          f.write('Test image content')
        end
      end

      post.image = File.open(file_path)
    end
  end
end
