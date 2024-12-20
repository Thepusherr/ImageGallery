class UserEvent < ApplicationRecord
  belongs_to :user

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["action_type", "created_at", "id", "id_value", "timestamp", "updated_at", "url", "user_id"]
  end
end
