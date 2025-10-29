# frozen_string_literal: true

class UserEvent < ApplicationRecord
  belongs_to :user

  # Add validations
  validates :action_type, presence: true
  validates :url, presence: true
  validates :user, presence: true

  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[action_type created_at id id_value timestamp updated_at url user_id]
  end
end
