# frozen_string_literal: true

namespace :app do
  desc 'Migrate images from Active Storage to CarrierWave'
  task migrate_images_to_carrierwave: :environment do
    puts 'Starting migration from Active Storage to CarrierWave...'

    migrated_count = 0
    failed_count = 0

    # Find all Active Storage attachments for Posts with name 'image'
    attachments = ActiveStorage::Attachment.where(record_type: 'Post', name: 'image').includes(:blob)

    attachments.find_each do |attachment|
      begin
        post = Post.find(attachment.record_id)
        blob = attachment.blob

        # Skip if post already has CarrierWave image
        next if post.image.present?

        puts "Migrating image for post ##{post.id}: #{blob.filename}"

        # Download the file from Active Storage
        temp_file = Tempfile.new([blob.filename.base, ".#{blob.filename.extension}"])
        temp_file.binmode
        temp_file.write(blob.download)
        temp_file.rewind

        # Create a new file object for CarrierWave
        uploaded_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: temp_file,
          filename: blob.filename.to_s,
          type: blob.content_type
        )

        # Save to CarrierWave
        post.image = uploaded_file

        if post.save
          puts "✓ Migrated image for post ##{post.id}: #{blob.filename}"
          migrated_count += 1
        else
          puts "✗ Failed to save post ##{post.id}: #{post.errors.full_messages.join(', ')}"
          failed_count += 1
        end

      rescue => e
        puts "✗ Error migrating post ##{attachment.record_id}: #{e.message}"
        failed_count += 1
      ensure
        temp_file&.close
        temp_file&.unlink
      end
    end

    puts "\nMigration completed!"
    puts "Successfully migrated: #{migrated_count} images"
    puts "Failed migrations: #{failed_count} images"

    if failed_count == 0
      puts "\n🎉 All images migrated successfully!"
      puts "You can now safely remove Active Storage attachments by running:"
      puts "rails app:cleanup_active_storage_attachments"
    end
  end
  
  desc 'Clean up Active Storage attachments after successful migration'
  task cleanup_active_storage_attachments: :environment do
    puts 'Cleaning up Active Storage attachments...'
    
    removed_count = 0
    
    Post.includes(image_attachment: :blob).find_each do |post|
      if post.image_attachment.present? && post.image.present?
        post.image_attachment.purge
        puts "✓ Removed Active Storage attachment for post ##{post.id}"
        removed_count += 1
      end
    end
    
    puts "\nCleanup completed!"
    puts "Removed #{removed_count} Active Storage attachments"
  end
end
