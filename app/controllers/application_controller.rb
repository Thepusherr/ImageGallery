class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_navigation

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :email, :password, :avatar, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname, :email, :password, :avatar, :password_confirmation])
  end

  private

  def track_navigation
    return unless current_user

    UserEventLogger.log(
      user: current_user,
      action_type: 'navigation',
      url: request.fullpath
    )
  end
end
