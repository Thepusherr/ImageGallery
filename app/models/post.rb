class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_one_attached :image
  has_many :comments
  has_many :categories
  has_many :likes
  has_many :likers, through: :likes, source: :user

  validates :image, presence: true
  # validate :image_size_validation

  private
  # def image_size_validation
  #   errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
  # end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "text", "title", "updated_at", "user_id"]
  end
end
