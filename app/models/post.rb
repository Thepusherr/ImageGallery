class Post < ApplicationRecord
  attribute :visibility, :integer
  enum visibility: { public_visibility: 0, private_visibility: 1, draft: 2 }
  enum visibility: { visible: 0, hidden: 1 }, _default: :visible
  
  belongs_to :user
  has_and_belongs_to_many :categories
  mount_uploader :image, ImageUploader
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, :text, :user, presence: true
  # validate_size_validation

  after_create :log_post_creation
  after_create :process_image_in_background
  after_create :notify_category_subscribers

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "text", "title", "updated_at", "user_id"]
  end

  private

  def log_post_creation
    UserEventLogger.log(user: user, action_type: 'post_creation', url: "/posts/#{id}")
  end

  def process_image_in_background
    return unless image.present?

    # Queue image processing jobs
    ImageProcessingJob.perform_later(id, 'optimize')
    ImageProcessingJob.perform_later(id, 'analyze')
  end

  def notify_category_subscribers
    # Notify users subscribed to this post's categories
    categories.each do |category|
      category.subscriptions.includes(:user).each do |subscription|
        next if subscription.user_id == user_id # Don't notify the post creator

        EmailNotificationJob.perform_later(
          'new_post_in_category',
          subscription.user.email,
          {
            post_title: title,
            category_name: category.name,
            author_name: user.name || user.email
          }
        )
      end
    end
  end
end
