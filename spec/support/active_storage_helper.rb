module ActiveStorageHelper
  # Helper method to set up ActiveStorage for tests
  def setup_active_storage_current_url_options
    ActiveStorage::Current.url_options = { host: 'test.host' }
  end
end

RSpec.configure do |config|
  config.include ActiveStorageHelper
  
  config.before(:each) do
    setup_active_storage_current_url_options
  end
end