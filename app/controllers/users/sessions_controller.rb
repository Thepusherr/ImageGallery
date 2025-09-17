# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Recaptcha::Verify

  before_action :check_recaptcha, only: [:create]
  before_action :initialize_recaptcha_service, only: [:new, :create]
  after_action :log_sign_in, only: :create
  after_action :log_sign_out, only: :destroy

  # GET /resource/sign_in
  def new
    @show_recaptcha = @recaptcha_service.recaptcha_required_for_login?(params[:user]&.dig(:email))
    super
  end

  # POST /resource/sign_in
  def create
    email = sign_in_params[:email]

    # Check if blocked
    if @recaptcha_service.blocked?(email)
      flash[:alert] = I18n.t('devise.failure.blocked', default: 'Too many failed attempts. Please try again later.')
      redirect_to new_user_session_path and return
    end

    # Record failed attempt if authentication fails
    begin
      super
      # If we get here, login was successful
      @recaptcha_service.clear_failed_attempts(email) if email.present?
    rescue StandardError
      # Authentication failed - record attempt
      @recaptcha_service.record_failed_login(email) if email.present?
      raise
    end
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

  protected

  def check_recaptcha
    email = sign_in_params[:email]
    return unless @recaptcha_service.recaptcha_required_for_login?(email)

    unless verify_recaptcha
      flash.now[:alert] = I18n.t('recaptcha.errors.verification_failed', default: 'Please complete the reCAPTCHA verification.')
      @show_recaptcha = true
      self.resource = resource_class.new(sign_in_params)
      render :new and return
    end
  end

  def initialize_recaptcha_service
    @recaptcha_service = RecaptchaService.new(request)
  end

  def sign_in_params
    params.require(:user).permit(:email, :password, :remember_me)
  end

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
