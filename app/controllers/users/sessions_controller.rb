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
    UserEventLogger.log(
      user: current_user,
      action_type: 'user_sign_in',
      url: root_path
    )
  end

  def log_sign_out
    UserEventLogger.log(
      user: current_user,
      action_type: 'user_sign_out',
      url: root_path
    )
  end
end
