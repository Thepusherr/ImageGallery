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

      if request.xhr?
        translations = {
          gallery_title: t('gallery.featured_gallery'),
          navigation: {
            home: t('navigation.home'),
            profile: t('navigation.profile'),
            about: t('navigation.about'),
            categories: t('navigation.categories'),
            services: t('navigation.services'),
            contact: t('navigation.contact')
          }
        }
        render json: { status: 'success', translations: translations }
      else
        redirect_to(request.referer || '/')
      end
    else
      if request.xhr?
        render json: { status: 'error' }
      else
        redirect_to(request.referer || '/', alert: t('language.invalid_locale'))
      end
    end
  end
end
