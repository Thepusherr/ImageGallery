class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user
  
  has_and_belongs_to_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post", "posts", "user", "users"]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end