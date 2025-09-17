# frozen_string_literal: true

class EmailNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_type, recipient_email, data = {})
    case notification_type
    when 'welcome'
      send_welcome_email(recipient_email, data)
    when 'new_comment'
      send_new_comment_email(recipient_email, data)
    when 'new_like'
      send_new_like_email(recipient_email, data)
    when 'new_post_in_category'
      send_new_post_in_category_email(recipient_email, data)
    else
      Rails.logger.error "Unknown notification type: #{notification_type}"
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send email notification: #{e.message}"
    raise e
  end

  private

  def send_welcome_email(email, data)
    Rails.logger.info "Sending welcome email to #{email}"
    # Here you would integrate with your email service (SendGrid, Mailgun, etc.)
    # For now, we'll just log it
    Rails.logger.info "Welcome email sent to #{email} for user: #{data[:user_name]}"
  end

  def send_new_comment_email(email, data)
    Rails.logger.info "Sending new comment notification to #{email}"
    Rails.logger.info "Comment on post '#{data[:post_title]}' by #{data[:commenter_name]}: #{data[:comment_text]}"
  end

  def send_new_like_email(email, data)
    Rails.logger.info "Sending new like notification to #{email}"
    Rails.logger.info "#{data[:liker_name]} liked your post '#{data[:post_title]}'"
  end

  def send_new_post_in_category_email(email, data)
    Rails.logger.info "Sending new post in category notification to #{email}"
    Rails.logger.info "New post '#{data[:post_title]}' in category '#{data[:category_name]}'"
  end
end
