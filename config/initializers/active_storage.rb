# Set default URL options for ActiveStorage
Rails.application.config.to_prepare do
  # Set default URL options for ActiveStorage based on environment
  if Rails.env.development?
    Rails.application.routes.default_url_options = { host: 'localhost', port: 3000 }
    ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
  elsif Rails.env.test?
    Rails.application.routes.default_url_options = { host: 'test.host' }
    ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
  else # production
    Rails.application.routes.default_url_options = { 
      host: ENV['HOST'] || 'yourdomain.com', 
      protocol: 'https' 
    }
    ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
  end
end

# Add a callback to set ActiveStorage::Current.url_options for each request
# Skip this in test environment to avoid issues with controller tests
unless Rails.env.test?
  ActiveSupport.on_load(:action_controller) do
    before_action do
      ActiveStorage::Current.url_options = request.base_url ? { host: request.host, port: request.port, protocol: request.protocol.sub('://', '') } : Rails.application.routes.default_url_options
    end
  end
end