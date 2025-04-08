# Add a test strategy for Warden in the test environment
Warden::Strategies.add(:test_mode) do
  def valid?
    # This strategy is only valid in test mode
    Warden.test_mode?
  end

  def authenticate!
    # In test mode, we'll just use the user that was set with login_as or sign_in
    if request.env['warden'].user(:user)
      success!(request.env['warden'].user(:user))
    else
      pass # Let other strategies handle it
    end
  end
end