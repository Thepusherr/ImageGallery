# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  after_action :log_sign_in, only: :create
  after_action :log_sign_out, only: :destroy

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def log_sign_in
    return if Rails.env.test? # Skip in test environment
    
    if defined?(UserEventLogger) && current_user
      begin
        UserEventLogger.log(
          user: current_user,
          action_type: 'user_sign_in',
          url: root_path
        )
      rescue => e
        Rails.logger.error("Failed to log sign in event: #{e.message}")
      end
    end
  end

  def log_sign_out
    return if Rails.env.test? # Skip in test environment
    return unless current_user # User might already be signed out
    
    if defined?(UserEventLogger)
      begin
        UserEventLogger.log(
          user: current_user,
          action_type: 'user_sign_out',
          url: root_path
        )
      rescue => e
        Rails.logger.error("Failed to log sign out event: #{e.message}")
      end
    end
  end
end
