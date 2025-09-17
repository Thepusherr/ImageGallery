# frozen_string_literal: true

require 'ostruct'

namespace :demo do
  desc 'Demonstrate Resque background jobs'
  task resque: :environment do
    puts "🚀 Demonstrating Resque background jobs..."
    
    # Queue some email notifications
    EmailNotificationJob.perform_later('welcome', 'demo@example.com', { user_name: 'Demo User' })
    puts "✅ Welcome email job queued"
    
    EmailNotificationJob.perform_later('new_comment', 'demo@example.com', {
      post_title: 'Demo Post',
      commenter_name: 'John Doe',
      comment_text: 'Great post!'
    })
    puts "✅ New comment notification job queued"
    
    # Queue image processing job if there are posts
    posts_with_images = Post.where.not(image: [nil, ''])
    if posts_with_images.any?
      post = posts_with_images.first
      ImageProcessingJob.perform_later(post.id, 'optimize')
      puts "✅ Image processing job queued for post: #{post.title}"
    end
    
    # Queue cleanup job
    CleanupJob.perform_later('old_user_events')
    puts "✅ Cleanup job queued"
    
    puts "\n📊 Jobs queued successfully! Check Resque web UI at: http://localhost:3000/admin/resque"
    puts "💡 To process jobs, run: bundle exec rake resque:work"
  end

  desc 'Demonstrate reCAPTCHA functionality'
  task recaptcha: :environment do
    puts "🔒 Demonstrating reCAPTCHA functionality..."
    
    # Simulate failed login attempts
    ip_address = '192.168.1.100'
    email = 'demo@example.com'
    
    puts "\n1. Recording failed login attempts..."
    3.times do |i|
      FailedLoginAttempt.record_failure(ip_address, email)
      puts "   Attempt #{i + 1} recorded"
    end
    
    # Check if reCAPTCHA is required
    request = OpenStruct.new(remote_ip: ip_address)
    recaptcha_service = RecaptchaService.new(request)
    
    puts "\n2. Checking if reCAPTCHA is required..."
    if recaptcha_service.recaptcha_required_for_login?(email)
      puts "   ✅ reCAPTCHA is now required for login from IP: #{ip_address}"
    else
      puts "   ❌ reCAPTCHA not required yet"
    end
    
    # Check if blocked
    if recaptcha_service.blocked?(email)
      puts "   🚫 IP/Email is currently blocked"
    else
      puts "   ✅ IP/Email is not blocked"
    end
    
    puts "\n3. Failed login attempts in database:"
    FailedLoginAttempt.all.each do |attempt|
      puts "   IP: #{attempt.ip_address}, Email: #{attempt.email}, Attempts: #{attempt.attempts_count}"
      puts "   Last attempt: #{attempt.last_attempt_at}"
      puts "   Blocked until: #{attempt.blocked_until || 'Not blocked'}"
    end
    
    puts "\n💡 To clear attempts: FailedLoginAttempt.clear_attempts('#{ip_address}', '#{email}')"
  end

  desc 'Clean up demo data'
  task cleanup: :environment do
    puts "🧹 Cleaning up demo data..."
    
    FailedLoginAttempt.delete_all
    puts "✅ Cleared all failed login attempts"
    
    # Clear Resque queues
    begin
      Resque.redis.flushdb
      puts "✅ Cleared Resque queues"
    rescue => e
      puts "⚠️  Could not clear Resque queues: #{e.message}"
    end
    
    puts "✨ Demo cleanup complete!"
  end
end
