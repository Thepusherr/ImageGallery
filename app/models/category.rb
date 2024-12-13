class Category < ApplicationRecord
  belongs_to :user
  
  has_and_belongs_to_many :posts

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post", "posts", "user", "users"]
  end
end
