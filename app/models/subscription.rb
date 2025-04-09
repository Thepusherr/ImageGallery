class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category
  
  validates :user_id, uniqueness: { scope: :category_id, message: "already subscribed to this category" }
  
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "id", "id_value", "updated_at", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["category", "user"]
  end
end