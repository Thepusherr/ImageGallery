# lib/tasks/migrate_images.rake

namespace :app do
  desc 'Migrate images from folders to categories'
  task migrate_images: :environment do
    user1 = User.create(name: 'Bert', surname: 'Berner', email: 'spunkspunkik112322333@gmail.com', password: '123123', password_confirmation: '123123')
    user1.avatar = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
    user1.save!

    # Assuming images are stored in 'public/images' directory
    image_folder = Rails.root.join('public', 'images')

    Dir.glob("#{image_folder}/*").each do |category_folder|
      category_name = File.basename(category_folder)
      category = Category.create(name: category_name, user: user1)

      Dir.glob("#{category_folder}/*.*").each do |image_path|
        p image_path
        post = Post.new(title: 'rake photo', text: '', user_id: user1.id)
        post.image = File.open(Rails.root.join(image_path))
        post.categories << category
        post.text = "image"
        post.save!
      end
    end         
  end
end