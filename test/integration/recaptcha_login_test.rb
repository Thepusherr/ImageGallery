require 'test_helper'

class RecaptchaLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one) # Assuming you have a fixture user
    @email = @user.email
    @password = 'password123'

    # Clear any existing failed attempts
    FailedLoginAttempt.destroy_all
  end

  test "should show login page without recaptcha initially" do
    get new_user_session_path
    assert_response :success
    assert_select 'form[action=?]', user_session_path
    assert_select 'input[name="user[email]"]'
    assert_select 'input[name="user[password]"]'
    # Should not show recaptcha initially
    refute_match /recaptcha/, response.body.downcase
  end

  test "should record failed login attempts using service directly" do
    # Test RecaptchaService directly
    request = ActionDispatch::TestRequest.create
    request.remote_ip = '127.0.0.1'
    service = RecaptchaService.new(request)

    # Record 3 failed attempts
    3.times do |i|
      service.record_failed_login(@email)
      failed_attempts = FailedLoginAttempt.where(email: @email).count
      assert_equal i + 1, failed_attempts, "Failed attempt #{i + 1} should be recorded"
    end

    # Should require reCAPTCHA after 3 attempts
    assert service.recaptcha_required_for_login?(@email), "Should require reCAPTCHA after 3 failed attempts"
  end

  test "should show recaptcha after 3 failed attempts" do
    # Create 3 failed attempts
    3.times do
      FailedLoginAttempt.create!(
        email: @email,
        ip_address: '127.0.0.1',
        attempts_count: 1,
        last_attempt_at: Time.current
      )
    end

    # Now try to access login page
    get new_user_session_path
    assert_response :success
    
    # Should show recaptcha warning
    assert_match /recaptcha/i, response.body
  end

  test "should clear failed attempts after successful login" do
    # Create some failed attempts
    3.times do
      FailedLoginAttempt.create!(
        email: @email,
        ip_address: '127.0.0.1',
        attempts_count: 1,
        last_attempt_at: Time.current
      )
    end

    # Successful login
    post user_session_path, params: {
      user: {
        email: @email,
        password: @password
      }
    }

    # Should redirect after successful login
    assert_response :redirect
    
    # Failed attempts should be cleared
    failed_attempts = FailedLoginAttempt.where(email: @email).count
    assert_equal 0, failed_attempts, "Failed attempts should be cleared after successful login"
  end

  test "recaptcha service should detect when recaptcha is required" do
    service = RecaptchaService.new(ActionDispatch::TestRequest.create)
    
    # Initially should not require recaptcha
    assert_not service.recaptcha_required_for_login?(@email)
    
    # Create 3 failed attempts
    3.times do
      FailedLoginAttempt.create!(
        email: @email,
        ip_address: '127.0.0.1',
        attempts_count: 1,
        last_attempt_at: Time.current
      )
    end
    
    # Now should require recaptcha
    assert service.recaptcha_required_for_login?(@email)
  end

  test "should record failed login attempt with correct data" do
    # Mock request with IP
    request = ActionDispatch::TestRequest.create
    request.remote_ip = '192.168.1.1'
    
    service = RecaptchaService.new(request)
    
    # Record failed attempt
    service.record_failed_login(@email)
    
    # Check that attempt was recorded correctly
    attempt = FailedLoginAttempt.last
    assert_equal @email, attempt.email
    assert_equal '192.168.1.1', attempt.ip_address
    assert_in_delta Time.current, attempt.last_attempt_at, 1.second
  end

  private

  def sign_in_user(email, password)
    post user_session_path, params: {
      user: {
        email: email,
        password: password
      }
    }
  end
end
