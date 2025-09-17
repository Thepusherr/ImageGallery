class Users::SessionsController < Devise::SessionsController
  before_action :initialize_recaptcha_service

  def new
    Rails.logger.debug "Users::SessionsController#new called"

    # Check if reCAPTCHA is required for any email (we don't have email in GET request)
    # We'll check this in the view based on IP address
    @recaptcha_required = false

    # If there are any recent failed attempts from this IP, show reCAPTCHA
    recent_failures = FailedLoginAttempt.recent
                                       .where(ip_address: request.remote_ip)
                                       .sum(:attempts_count)

    @recaptcha_required = recent_failures >= 3

    Rails.logger.debug "reCAPTCHA required: #{@recaptcha_required}, recent failures: #{recent_failures}"

    super
  end

  def create
    Rails.logger.debug "Users::SessionsController#create called"
    email = sign_in_params[:email]

    # Check if reCAPTCHA is required and verify it
    if @recaptcha_service.recaptcha_required_for_login?(email)
      @recaptcha_required = true
      unless verify_recaptcha_if_required
        @recaptcha_service.record_failed_login(email)
        flash.now[:alert] = I18n.t('devise.failure.recaptcha_failed', default: 'Please complete the reCAPTCHA verification.')
        self.resource = resource_class.new(sign_in_params)
        render :new and return
      end
    end

    # Attempt authentication
    self.resource = warden.authenticate(auth_options)

    if resource
      # Successful login - clear failed attempts
      @recaptcha_service.clear_failed_attempts(email)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      # Failed login - record attempt and check if reCAPTCHA is now required
      @recaptcha_service.record_failed_login(email)
      @recaptcha_required = @recaptcha_service.recaptcha_required_for_login?(email)
      flash.now[:alert] = I18n.t('devise.failure.invalid', default: 'Invalid email or password.')
      self.resource = resource_class.new(sign_in_params)
      render :new
    end
  end

  private

  def initialize_recaptcha_service
    @recaptcha_service = RecaptchaService.new(request)
  end

  def verify_recaptcha_if_required
    return true unless @recaptcha_required
    verify_recaptcha(model: resource, message: I18n.t('devise.failure.recaptcha_failed', default: 'reCAPTCHA verification failed'))
  end

  def sign_in_params
    return {} unless params[:user].present?
    params.require(:user).permit(:email, :password, :remember_me)
  end
end
