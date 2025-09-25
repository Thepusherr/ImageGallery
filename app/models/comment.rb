class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :text, presence: true

  after_create :log_comment_event
  after_create :send_notification_email

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "post_id", "text", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post", "user"]
  end

  private

  def log_comment_event
    return if Rails.env.test?

    begin
      UserEventLogger.log(
        user: user,
        action_type: 'comment',
        url: "/posts/#{post.id}"
      )
    rescue => e
      Rails.logger.error("Failed to log comment event: #{e.message}")
    end
  end

  def send_notification_email
    # Send email notification to post owner (if different from commenter)
    return if post.user_id == user.id

    EmailNotificationJob.perform_later(
      'new_comment',
      post.user.email,
      {
        post_title: post.title,
        commenter_name: user.name || user.email,
        comment_text: text.truncate(100)
      }
    )
  end
end
