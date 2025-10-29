# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user_id, uniqueness: { scope: :category_id, message: 'already subscribed to this category' }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id id_value updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category user]
  end
end
