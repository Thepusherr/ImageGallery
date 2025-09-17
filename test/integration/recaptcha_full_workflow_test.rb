require 'test_helper'

class RecaptchaFullWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @email = @user.email
    @password = 'password123'
    
    # Clear any existing failed attempts
    FailedLoginAttempt.destroy_all
  end

  test "complete reCAPTCHA workflow" do
    puts "\n=== Testing Complete reCAPTCHA Workflow ==="
    
    # Step 1: Initial login page should not show reCAPTCHA
    puts "Step 1: Checking initial login page..."
    get new_user_session_path
    assert_response :success
    refute_match(/recaptcha/i, response.body)
    puts "✓ Initial page does not show reCAPTCHA"
    
    # Step 2: Make 3 failed login attempts
    puts "Step 2: Making 3 failed login attempts..."
    3.times do |i|
      post user_session_path, params: {
        user: {
          email: @email,
          password: 'wrong_password'
        }
      }
      
      assert_response :success
      failed_count = FailedLoginAttempt.where(email: @email).count
      puts "  Attempt #{i + 1}: #{failed_count} failed attempts recorded"
    end
    
    # Step 3: After 3 failed attempts, login page should show reCAPTCHA
    puts "Step 3: Checking if reCAPTCHA appears after failed attempts..."
    get new_user_session_path
    assert_response :success
    
    if response.body.match(/recaptcha/i)
      puts "✓ reCAPTCHA found on login page after failed attempts"
    else
      puts "✗ reCAPTCHA NOT found on login page"
    end
    
    # Step 4: Successful login should clear failed attempts
    puts "Step 4: Testing successful login clears failed attempts..."
    initial_count = FailedLoginAttempt.where(email: @email).count
    puts "  Failed attempts before login: #{initial_count}"
    
    post user_session_path, params: {
      user: {
        email: @email,
        password: @password
      }
    }
    
    # Should redirect after successful login
    assert_response :redirect
    
    final_count = FailedLoginAttempt.where(email: @email).count
    puts "  Failed attempts after login: #{final_count}"
    
    if final_count == 0
      puts "✓ Failed attempts cleared after successful login"
    else
      puts "✗ Failed attempts NOT cleared after successful login"
    end
    
    # Step 5: After successful login and logout, should not show reCAPTCHA
    puts "Step 5: Checking login page after successful login/logout..."
    delete destroy_user_session_path
    
    get new_user_session_path
    assert_response :success
    
    if response.body.match(/recaptcha/i)
      puts "✗ reCAPTCHA still showing after successful login/logout"
    else
      puts "✓ reCAPTCHA not showing after successful login/logout"
    end
    
    puts "=== Workflow Test Complete ==="
  end

  test "reCAPTCHA service logic" do
    puts "\n=== Testing reCAPTCHA Service Logic ==="
    
    request = ActionDispatch::TestRequest.create
    request.remote_ip = '192.168.1.100'
    service = RecaptchaService.new(request)
    
    # Initially should not require reCAPTCHA
    refute service.recaptcha_required_for_login?(@email)
    puts "✓ Initially does not require reCAPTCHA"
    
    # Record 2 failed attempts - should not require reCAPTCHA yet
    2.times { service.record_failed_login(@email) }
    refute service.recaptcha_required_for_login?(@email)
    puts "✓ After 2 failed attempts, does not require reCAPTCHA"
    
    # Record 3rd failed attempt - should now require reCAPTCHA
    service.record_failed_login(@email)
    assert service.recaptcha_required_for_login?(@email)
    puts "✓ After 3 failed attempts, requires reCAPTCHA"
    
    # Clear attempts - should not require reCAPTCHA anymore
    service.clear_failed_attempts(@email)
    refute service.recaptcha_required_for_login?(@email)
    puts "✓ After clearing attempts, does not require reCAPTCHA"
    
    puts "=== Service Logic Test Complete ==="
  end

  test "failed login attempt model" do
    puts "\n=== Testing FailedLoginAttempt Model ==="
    
    ip = '10.0.0.1'
    email = 'test@example.com'
    
    # Test record_failure method
    result = FailedLoginAttempt.record_failure(ip, email)
    assert result.persisted?
    assert_equal ip, result.ip_address
    assert_equal email, result.email
    assert_equal 1, result.attempts_count
    puts "✓ record_failure creates new record correctly"
    
    # Test incrementing existing record
    result2 = FailedLoginAttempt.record_failure(ip, email)
    assert_equal result.id, result2.id  # Same record
    assert_equal 2, result2.attempts_count
    puts "✓ record_failure increments existing record"
    
    # Test blocked? method
    refute FailedLoginAttempt.blocked?(ip, email)
    puts "✓ Not blocked with 2 attempts"
    
    # Add one more attempt to reach threshold
    FailedLoginAttempt.record_failure(ip, email)
    assert FailedLoginAttempt.blocked?(ip, email)
    puts "✓ Blocked after 3 attempts"
    
    # Test clear_attempts
    FailedLoginAttempt.clear_attempts(ip, email)
    refute FailedLoginAttempt.blocked?(ip, email)
    puts "✓ Not blocked after clearing attempts"
    
    puts "=== Model Test Complete ==="
  end
end
