class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, uniqueness: { scope: :post_id }

  def self.ransackable_associations(auth_object = nil)
    ["post", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "id", "id_value", "post_id", "updated_at", "user_id"]
  end
end
