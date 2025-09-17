class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, uniqueness: { scope: :post_id }

  after_create :log_like_event
  after_create :send_like_notification

  def self.ransackable_associations(auth_object = nil)
    ["post", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "id", "id_value", "post_id", "updated_at", "user_id"]
  end

  private

  def log_like_event
    UserEventLogger.log(user, 'like', "/posts/#{post.id}", { like_id: id, post_id: post.id })
  end

  def send_like_notification
    # Send email notification to post owner (if different from liker)
    return if post.user_id == user.id

    EmailNotificationJob.perform_later(
      'new_like',
      post.user.email,
      {
        post_title: post.title,
        liker_name: user.name || user.email
      }
    )
  end
end
