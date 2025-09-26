class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :track_navigation
  before_action :load_navbar_categories

  rescue_from StandardError, with: :render_500_error

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :email, :password, :avatar, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname, :email, :password, :avatar, :password_confirmation])
  end

  private

  def load_navbar_categories
    if current_user
      # For logged-in users: show their categories and subscriptions first, then popular ones
      user_categories = current_user.categories.where(visibility: :visible)
      subscribed_categories = current_user.subscriptions.includes(:category)
                                         .map(&:category)
                                         .select { |cat| cat.visibility == 'visible' }

      user_relevant_categories = (user_categories + subscribed_categories).uniq

      # Fill remaining slots with popular categories
      remaining_slots = 8 - user_relevant_categories.size
      if remaining_slots > 0
        popular_categories = Category.where(visibility: :visible)
                                   .where.not(id: user_relevant_categories.map(&:id))
                                   .limit(remaining_slots)
        @navbar_categories = user_relevant_categories + popular_categories.to_a
      else
        @navbar_categories = user_relevant_categories.first(8)
      end
    else
      # For guests: show popular categories
      @navbar_categories = Category.where(visibility: :visible).limit(8)
    end
  rescue => e
    Rails.logger.error("Failed to load navbar categories: #{e.message}")
    @navbar_categories = []
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def track_navigation
    return unless current_user
    return if Rails.env.test? # Skip tracking in test environment

    # Only track if UserEventLogger is defined
    if defined?(UserEventLogger)
      begin
        UserEventLogger.log(
          user: current_user,
          action_type: 'navigation',
          url: request.fullpath
        )
      rescue => e
        Rails.logger.error("Failed to log navigation event: #{e.message}")
      end
    end
  end

  def render_500_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))
    render file: 'public/500.html', status: :internal_server_error, layout: false
  end
end
