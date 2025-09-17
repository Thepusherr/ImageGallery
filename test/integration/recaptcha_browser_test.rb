require 'test_helper'

class RecaptchaBrowserTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @email = @user.email
    @password = 'password123'
    
    # Clear any existing failed attempts
    FailedLoginAttempt.destroy_all
  end

  test "browser simulation - reCAPTCHA workflow" do
    puts "\n=== Browser Simulation Test ==="
    
    # Simulate consistent IP address by creating failed attempts manually
    ip_address = '127.0.0.1'
    
    # Step 1: Create 3 failed attempts for the same IP/email combination
    puts "Creating 3 failed login attempts..."
    3.times do |i|
      FailedLoginAttempt.record_failure(ip_address, @email)
      count = FailedLoginAttempt.where(email: @email, ip_address: ip_address).sum(:attempts_count)
      puts "  After attempt #{i + 1}: #{count} total attempts"
    end
    
    # Step 2: Check that reCAPTCHA service detects the need for reCAPTCHA
    request = ActionDispatch::TestRequest.create
    request.remote_ip = ip_address
    service = RecaptchaService.new(request)
    
    if service.recaptcha_required_for_login?(@email)
      puts "✓ reCAPTCHA service correctly detects need for reCAPTCHA"
    else
      puts "✗ reCAPTCHA service does NOT detect need for reCAPTCHA"
    end
    
    # Step 3: Access login page and check if reCAPTCHA appears
    # We need to mock the request IP to match our test data
    get new_user_session_path, headers: { 'REMOTE_ADDR' => ip_address }
    assert_response :success
    
    if response.body.match(/recaptcha/i)
      puts "✓ reCAPTCHA appears on login page"
    else
      puts "✗ reCAPTCHA does NOT appear on login page"
    end
    
    # Step 4: Test successful login clears attempts
    puts "Testing successful login..."
    post user_session_path, params: {
      user: {
        email: @email,
        password: @password
      }
    }, headers: { 'REMOTE_ADDR' => ip_address }
    
    # Should redirect after successful login
    assert_response :redirect
    
    # Check if attempts were cleared
    remaining_attempts = FailedLoginAttempt.where(email: @email, ip_address: ip_address).count
    if remaining_attempts == 0
      puts "✓ Failed attempts cleared after successful login"
    else
      puts "✗ Failed attempts NOT cleared (#{remaining_attempts} remaining)"
    end
    
    puts "=== Browser Simulation Complete ==="
  end

  test "manual reCAPTCHA verification" do
    puts "\n=== Manual reCAPTCHA Verification ==="
    puts "This test verifies the reCAPTCHA logic without browser interaction"
    
    # Test the core logic
    ip = '192.168.1.1'
    email = 'test@recaptcha.com'
    
    # Create request mock
    request = ActionDispatch::TestRequest.create
    request.remote_ip = ip
    service = RecaptchaService.new(request)
    
    # Initially no reCAPTCHA required
    refute service.recaptcha_required_for_login?(email)
    puts "✓ No reCAPTCHA required initially"
    
    # Record failures and check threshold
    (1..5).each do |i|
      service.record_failed_login(email)
      required = service.recaptcha_required_for_login?(email)
      
      if i < 3
        refute required, "Should not require reCAPTCHA after #{i} attempts"
        puts "✓ No reCAPTCHA required after #{i} attempts"
      else
        assert required, "Should require reCAPTCHA after #{i} attempts"
        puts "✓ reCAPTCHA required after #{i} attempts"
      end
    end
    
    # Clear and verify
    service.clear_failed_attempts(email)
    refute service.recaptcha_required_for_login?(email)
    puts "✓ reCAPTCHA not required after clearing attempts"
    
    puts "=== Manual Verification Complete ==="
  end
end
