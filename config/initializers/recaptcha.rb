# frozen_string_literal: true

Recaptcha.configure do |config|
  # Use test keys for development (these always pass)
  config.site_key = ENV.fetch('RECAPTCHA_SITE_KEY', '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI')
  config.secret_key = ENV.fetch('RECAPTCHA_SECRET_KEY', '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe')

  # Optional: Skip verification in test environment
  config.skip_verify_env = ['test']
end
