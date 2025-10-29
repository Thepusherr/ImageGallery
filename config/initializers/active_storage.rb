# frozen_string_literal: true

# Set default URL options for ActiveStorage
Rails.application.config.to_prepare do
  # Set default URL options for ActiveStorage based on environment
  Rails.application.routes.default_url_options = if Rails.env.development?
                                                   { host: 'localhost', port: 3000 }
                                                 elsif Rails.env.test?
                                                   { host: 'test.host' }
                                                 else # production
                                                   {
                                                     host: ENV['HOST'] || 'yourdomain.com',
                                                     protocol: 'https'
                                                   }
                                                 end
  ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
end

# Add a callback to set ActiveStorage::Current.url_options for each request
# Skip this in test environment to avoid issues with controller tests
unless Rails.env.test?
  ActiveSupport.on_load(:action_controller) do
    before_action do
      ActiveStorage::Current.url_options = if request.base_url
                                             { host: request.host, port: request.port,
                                               protocol: request.protocol.sub('://', '') }
                                           else
                                             Rails.application.routes.default_url_options
                                           end
    end
  end
end
