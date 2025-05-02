class Post < ApplicationRecord
  attribute :visibility, :integer
  enum visibility: { public_visibility: 0, private_visibility: 1, draft: 2 }
  enum visibility: { visible: 0, hidden: 1 }, _default: :visible
  
  belongs_to :user
  has_and_belongs_to_many :categories
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, :text, :user, presence: true
  # validate_size_validation

  private

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "text", "title", "updated_at", "user_id"]
  end
end
