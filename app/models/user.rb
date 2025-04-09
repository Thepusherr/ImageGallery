class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # # mount_uploader :avatar, AvatarUploader

  has_one_attached :avatar
  has_many :posts
  has_many :categories
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_categories, through: :subscriptions, source: :category
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_categories, through: :subscriptions, source: :category

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # # validates_presence_of   :avatar
  # # validates_integrity_of  :avatar
  # # validates_processing_of :avatar
  # # validate :avatar_size_validation

  # By default, all user profiles are public
  def public_profile?
    true
  end
  
  # Check if user is an admin
  def admin?
    false # For now, no users are admins
  end

  private
  def avatar_size_validation
    errors[:avatar] << "should be less than 50 MB" if avatar.size > 50.megabytes
  end

  def self.ransackable_associations(auth_object = nil)
    ["avatar_attachment", "avatar_blob", "categories", "posts"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["avatar", "created_at", "email", "encrypted_password", "id", "id_value", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "slug", "surname", "updated_at", "username"]
  end
end
