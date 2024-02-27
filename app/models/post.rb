class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image
  has_many :comments
  has_many :categories

  validates_presence_of   :image
  validate :image_size_validation

  private
  def image_size_validation
    errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
  end
end
