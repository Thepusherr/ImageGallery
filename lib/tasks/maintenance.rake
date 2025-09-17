# frozen_string_literal: true

namespace :maintenance do
  desc 'Run daily cleanup tasks'
  task daily_cleanup: :environment do
    puts "Starting daily cleanup tasks..."
    
    CleanupJob.perform_later('all')
    
    puts "Daily cleanup tasks queued successfully!"
  end

  desc 'Clean up old user events'
  task cleanup_user_events: :environment do
    puts "Cleaning up old user events..."
    
    CleanupJob.perform_later('old_user_events')
    
    puts "User events cleanup queued!"
  end

  desc 'Clean up orphaned images'
  task cleanup_orphaned_images: :environment do
    puts "Cleaning up orphaned images..."
    
    CleanupJob.perform_later('orphaned_images')
    
    puts "Orphaned images cleanup queued!"
  end

  desc 'Process all pending image optimizations'
  task process_images: :environment do
    puts "Processing pending image optimizations..."
    
    # Find posts with images that haven't been processed recently
    Post.where.not(image: [nil, '']).find_each do |post|
      ImageProcessingJob.perform_later(post.id, 'optimize')
    end
    
    puts "Image processing jobs queued!"
  end

  desc 'Send test email notification'
  task :test_email, [:email] => :environment do |_t, args|
    email = args[:email] || 'test@example.com'
    puts "Sending test email to #{email}..."
    
    EmailNotificationJob.perform_later(
      'welcome',
      email,
      {
        user_name: 'Test User',
        username: 'testuser'
      }
    )
    
    puts "Test email queued!"
  end
end
