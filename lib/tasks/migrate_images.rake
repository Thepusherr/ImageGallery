# lib/tasks/migrate_images.rake

namespace :app do
  desc 'Migrate images from folders to categories'
  task migrate_images: :environment do
    # Assuming images are stored in 'public/images' directory
    image_folder = Rails.root.join('public', 'images')

    Dir.glob("#{image_folder}/*").each do |category_folder|
      category_name = File.basename(category_folder)
      category = Category.find_or_create_by(name: category_name)

      Dir.glob("#{category_folder}/*.jpg").each do |image_path|
        category.images.create(image: File.open(image_path))
      end
    end
  end
end