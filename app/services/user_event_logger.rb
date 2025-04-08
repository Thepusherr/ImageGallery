class UserEventLogger
  def self.log_navigation(user:, url:)
    log(user: user, action_type: 'navigation', url: url)
  end

  def self.log(user:, action_type:, url:)
    # Skip actual logging in test environment
    return true if Rails.env.test?
    
    begin
      if defined?(Pusher) && Pusher.app_id.present?
        Pusher.trigger('activity_log_channel', 'new_action', {
          user: user.email,
          action_type: action_type,
          url: url,
          timestamp: Time.current
        })
      end
    rescue => e
      Rails.logger.error("Error triggering Pusher event: #{e.message}")
    end

    UserEvent.create!(
      user: user,
      action_type: action_type,
      url: url,
      timestamp: Time.current
    )
  end
end