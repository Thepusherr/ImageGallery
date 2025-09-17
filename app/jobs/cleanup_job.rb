# frozen_string_literal: true

class CleanupJob < ApplicationJob
  queue_as :low_priority

  def perform(cleanup_type = 'all')
    case cleanup_type
    when 'old_user_events'
      cleanup_old_user_events
    when 'orphaned_images'
      cleanup_orphaned_images
    when 'expired_sessions'
      cleanup_expired_sessions
    when 'all'
      cleanup_old_user_events
      cleanup_orphaned_images
      cleanup_expired_sessions
    else
      Rails.logger.error "Unknown cleanup type: #{cleanup_type}"
    end
  rescue StandardError => e
    Rails.logger.error "Failed to perform cleanup: #{e.message}"
    raise e
  end

  private

  def cleanup_old_user_events
    Rails.logger.info "Starting cleanup of old user events"
    
    # Delete user events older than 30 days
    cutoff_date = 30.days.ago
    deleted_count = UserEvent.where('created_at < ?', cutoff_date).delete_all
    
    Rails.logger.info "Deleted #{deleted_count} old user events"
  end

  def cleanup_orphaned_images
    Rails.logger.info "Starting cleanup of orphaned images"
    
    # This would check for image files that don't have corresponding posts
    # For now, we'll just log it as this requires file system operations
    Rails.logger.info "Orphaned image cleanup completed (placeholder)"
  end

  def cleanup_expired_sessions
    Rails.logger.info "Starting cleanup of expired sessions"
    
    # This would clean up expired user sessions
    # Implementation depends on your session store
    Rails.logger.info "Expired session cleanup completed (placeholder)"
  end
end
