FactoryBot.define do
  factory :post do
    title { 'Test Post' }
    text { 'Test Content' }
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
  end
end
