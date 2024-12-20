class UserEventLogger
  def self.log_navigation(user:, url:)
    log(user: user, action_type: 'navigation', url: url)
  end

  private
  
  def self.log(user:, action_type:, url:)
    Pusher.trigger('activity_log_channel', 'new_action', {
      user: user.email,
      action_type: action_type,
      url: url,
      timestamp: Time.current
    })

    UserEvent.create!(
      user: user,
      action_type: action_type,
      url: url,
      timestamp: Time.current
    )
  end
end