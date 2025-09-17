# frozen_string_literal: true

# Controller for handling locale switching
class LocalesController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :set_locale, raise: false

  def switch
    locale = params[:locale]

    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = locale
      I18n.locale = locale

      redirect_to(request.referer || '/', notice: "Language switched to #{locale}")
    else
      redirect_to(request.referer || '/', alert: 'Invalid locale')
    end
  end
end
