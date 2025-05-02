FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    name { 'Test User' }
    surname { 'Surname' }
    
    # Skip avatar attachment in basic factory to speed up tests
    
    trait :with_avatar do
      after(:build) do |user|
        # Create a simple test avatar
        file_path = Rails.root.join('spec/fixtures/test_avatar.jpg')
          
        # Create the directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(file_path)) unless File.directory?(File.dirname(file_path))
            
        # Create a simple test image if it doesn't exist
        unless File.exist?(file_path)
          File.open(file_path, 'wb') do |f|
            f.write('Test avatar content')
          end
        end     
          
        user.avatar.attach(io: File.open(file_path), filename: 'test_avatar.jpg', content_type: 'image/jpeg')
      end
    end
    
    trait :with_posts do
      after(:create) do |user|
        create_list(:post, 3, user: user)
      end
    end
  end
end
