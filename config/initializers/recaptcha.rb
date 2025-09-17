# frozen_string_literal: true

Recaptcha.configure do |config|
  config.site_key = ENV.fetch('RECAPTCHA_SITE_KEY', 'your_site_key_here')
  config.secret_key = ENV.fetch('RECAPTCHA_SECRET_KEY', 'your_secret_key_here')
  
  # Optional: Skip verification in test environment
  config.skip_verify_env = ['test']
end
