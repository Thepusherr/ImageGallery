FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    name { 'Test User' }
    avatar { 
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/test_avatar.jpg'), 
        'image/jpeg'
      ) 
    }
    
    trait :with_posts do
      after(:create) do |user|
        create_list(:post, 3, user: user)
      end
    end
  end
end
