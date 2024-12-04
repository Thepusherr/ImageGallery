class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :text, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "post_id", "text", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post", "user"]
  end
end
