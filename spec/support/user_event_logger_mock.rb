# Mock UserEventLogger for tests
class UserEventLogger
  # Track method calls for debugging
  @@calls = []

  def self.calls
    @@calls
  end

  def self.reset_calls
    @@calls = []
  end

  def self.log_navigation(user:, url:)
    # Record the call but don't do anything
    @@calls << { method: :log_navigation, user: user, url: url }
    true
  end

  def self.log(user:, action_type:, url:, metadata: nil)
    # Record the call but don't do anything
    @@calls << { method: :log, user: user, action_type: action_type, url: url, metadata: metadata }
    true
  end

  # Add any other methods that might be called
  def self.method_missing(method_name, *args, **kwargs)
    # Record the call but don't do anything
    @@calls << { method: method_name, args: args, kwargs: kwargs }
    true
  end
end