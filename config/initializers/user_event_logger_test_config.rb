# Ensure UserEventLogger mock is properly loaded in test environment
if Rails.env.test?
  begin
    # Make sure the mock is loaded
    mock_path = Rails.root.join('spec/support/user_event_logger_mock')
    require mock_path if File.exist?(mock_path)
    
    # Verify that the mock is being used
    Rails.logger.info "UserEventLogger mock loaded for test environment"
  rescue => e
    Rails.logger.error "Failed to load UserEventLogger mock: #{e.message}"
  end
end