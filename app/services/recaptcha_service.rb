# frozen_string_literal: true

class RecaptchaService
  def initialize(request)
    @request = request
    @ip_address = request.remote_ip
  end

  # Check if reCAPTCHA is required for login
  def recaptcha_required_for_login?(email)
    return false if Rails.env.test? # Skip in tests
    
    FailedLoginAttempt.blocked?(@ip_address, email) ||
      recent_failed_attempts_count(email) >= 3
  end

  # Check if reCAPTCHA is required for comments (spam protection)
  def recaptcha_required_for_comment?(user)
    return false if Rails.env.test? # Skip in tests
    return false if user.nil? # Require login for comments
    
    # Require reCAPTCHA if user has posted many comments recently
    recent_comments_count = user.comments.where('created_at > ?', 10.minutes.ago).count
    recent_comments_count >= 3
  end

  # Verify reCAPTCHA response
  def verify_recaptcha(recaptcha_response)
    return true if Rails.env.test? # Skip verification in tests

    Recaptcha.verify_recaptcha(
      response: recaptcha_response,
      remote_ip: @ip_address
    )
  end

  # Record failed login attempt
  def record_failed_login(email)
    FailedLoginAttempt.record_failure(@ip_address, email)
  end

  # Clear failed attempts on successful login
  def clear_failed_attempts(email)
    FailedLoginAttempt.clear_attempts(@ip_address, email)
  end

  # Check if IP/email is currently blocked
  def blocked?(email = nil)
    FailedLoginAttempt.blocked?(@ip_address, email)
  end

  private

  def recent_failed_attempts_count(email)
    FailedLoginAttempt.recent
                     .where(ip_address: @ip_address)
                     .or(FailedLoginAttempt.recent.where(email: email))
                     .sum(:attempts_count)
  end
end
