begin
  require 'pusher'

  # Skip Pusher configuration in test environment
  unless Rails.env.test?
    Pusher.app_id = ENV['PUSHER_APP_ID']
    Pusher.key = ENV['PUSHER_KEY']
    Pusher.secret = ENV['PUSHER_SECRET']
    Pusher.cluster = ENV['PUSHER_CLUSTER']
    Pusher.logger = Rails.logger
    Pusher.encrypted = true
  else
    # Define dummy methods for Pusher in test environment
    unless Pusher.respond_to?(:trigger)
      Pusher.define_singleton_method(:trigger) do |*args|
        # Do nothing in tests
        true
      end
    end
    
    unless Pusher.respond_to?(:app_id)
      Pusher.define_singleton_method(:app_id) do
        nil
      end
    end
    
    Rails.logger.info "Dummy Pusher configured for test environment"
  end
rescue => e
  Rails.logger.error "Failed to configure Pusher: #{e.message}"
end