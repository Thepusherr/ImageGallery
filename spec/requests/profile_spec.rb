# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/profile'
      expect(response).to have_http_status(:found) # 302
      expect(response).to redirect_to(edit_user_registration_path)
    end
  end
end
