# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocalesController, type: :controller do
  describe 'GET #switch' do
    context 'with valid locale' do
      it 'switches to English' do
        get :switch, params: { locale: 'en' }
        
        expect(session[:locale]).to eq('en')
        expect(response).to redirect_to(root_path)
      end

      it 'switches to Russian' do
        get :switch, params: { locale: 'ru' }
        
        expect(session[:locale]).to eq('ru')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid locale' do
      it 'redirects with alert for invalid locale' do
        get :switch, params: { locale: 'invalid' }

        expect(session[:locale]).to be_nil
        expect(response).to be_redirect
      end
    end
  end
end
