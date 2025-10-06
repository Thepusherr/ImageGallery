# lib/tasks/migrate_images.rake

namespace :app do
  desc 'Migrate images from folders to categories'
  task migrate_images: :environment do
    # Find or create user to avoid duplicate email errors
    user1 = User.find_or_create_by(email: 'spunkspunkik112322333@gmail.com') do |user|
      user.name = 'Bert'
      user.surname = 'Berner'
      user.username = 'bert_berner' # Add username to avoid validation error
      user.password = '123123'
      user.password_confirmation = '123123'
    end

    # Only attach avatar if user doesn't have one
    if user1.avatar.blank? && File.exist?(Rails.root.join('app/assets/images/default-avatar.png'))
      user1.avatar = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
      user1.save!
    end

    # Assuming images are stored in 'public/images' directory
    image_folder = Rails.root.join('public', 'images')

    unless Dir.exist?(image_folder)
      puts "Image folder #{image_folder} does not exist. Skipping migration."
      return
    end

    Dir.glob("#{image_folder}/*").each do |category_folder|
      next unless File.directory?(category_folder)

      category_name = File.basename(category_folder)
      # Find or create category to avoid duplicates
      category = Category.find_or_create_by(name: category_name, user: user1)

      Dir.glob("#{category_folder}/*.*").each do |image_path|
        next unless File.file?(image_path)

        puts "Processing image: #{image_path}"

        begin
          post = Post.new(title: 'rake photo', text: 'image', user_id: user1.id)
          post.image = File.open(image_path)
          post.categories << category
          post.save!
          puts "Successfully created post for #{File.basename(image_path)}"
        rescue StandardError => e
          puts "Error creating post for #{image_path}: #{e.message}"
        end
      end
    end

    puts 'Image migration completed!'
  end
end