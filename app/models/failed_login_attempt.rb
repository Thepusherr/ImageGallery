# frozen_string_literal: true

class FailedLoginAttempt < ApplicationRecord
  validates :ip_address, presence: true
  validates :email, presence: true
  validates :attempts_count, presence: true, numericality: { greater_than: 0 }

  scope :recent, -> { where('last_attempt_at > ?', 1.hour.ago) }
  scope :blocked, -> { where('blocked_until > ?', Time.current) }

  # Check if IP or email is currently blocked
  def self.blocked?(ip_address, email = nil)
    query = where(ip_address: ip_address)
    query = query.or(where(email: email)) if email.present?
    query.blocked.exists?
  end

  # Record a failed login attempt
  def self.record_failure(ip_address, email)
    Rails.logger.debug "FailedLoginAttempt: Recording failure for #{email} from #{ip_address}"
    attempt = find_or_initialize_by(ip_address: ip_address, email: email)
    Rails.logger.debug "FailedLoginAttempt: Found/created attempt: #{attempt.inspect}"

    if attempt.persisted?
      Rails.logger.debug "FailedLoginAttempt: Incrementing existing attempt"
      attempt.increment!(:attempts_count)
    else
      Rails.logger.debug "FailedLoginAttempt: Creating new attempt"
      attempt.attempts_count = 1
    end

    attempt.update!(
      last_attempt_at: Time.current,
      blocked_until: attempt.should_be_blocked? ? 1.hour.from_now : nil
    )

    Rails.logger.debug "FailedLoginAttempt: Final attempt: #{attempt.inspect}"
    attempt
  end

  # Clear failed attempts for successful login
  def self.clear_attempts(ip_address, email)
    where(ip_address: ip_address, email: email).delete_all
  end

  # Check if this attempt should trigger a block
  def should_be_blocked?
    attempts_count >= 3
  end

  # Check if currently blocked
  def blocked?
    blocked_until.present? && blocked_until > Time.current
  end
end
