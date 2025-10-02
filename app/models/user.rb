class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  # Define slug candidates for friendly_id
  def slug_candidates
    [
      :username,
      [:name, :surname],
      [:name, :surname, :id]
    ]
  end
  
  # Regenerate slug when name, surname or username changes
  def should_generate_new_friendly_id?
    name_changed? || surname_changed? || username_changed? || slug.blank?
  end

  # # mount_uploader :avatar, AvatarUploader

  has_one_attached :avatar
  has_many :posts
  has_many :categories
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_categories, through: :subscriptions, source: :category
  has_many :views, dependent: :destroy
  has_many :viewed_posts, through: :views, source: :post

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable,
         omniauth_providers: [:github, :google_oauth2]

  # Validations
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true

  after_create :send_welcome_email

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

  # OmniAuth methods
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = (auth.info.name.present? && auth.info.name != auth.info.email) ? auth.info.name : (auth.info.first_name || 'User')
      user.surname = auth.info.last_name || 'Surname'
      user.username = generate_username_from_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def self.generate_username_from_email(email)
    base_username = email.split('@').first.gsub(/[^a-zA-Z0-9]/, '')
    username = base_username
    counter = 1

    while User.exists?(username: username)
      username = "#{base_username}#{counter}"
      counter += 1
    end

    username
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

  private

  def send_welcome_email
    EmailNotificationJob.perform_later(
      'welcome',
      email,
      {
        user_name: "#{name} #{surname}".strip,
        username: username
      }
    )
  end
end
