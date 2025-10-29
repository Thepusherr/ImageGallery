# frozen_string_literal: true

class Category < ApplicationRecord
  enum visibility: { visible: 0, hidden: 1 }, _default: :visible
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user

  has_and_belongs_to_many :posts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :user, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[post posts user users]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
