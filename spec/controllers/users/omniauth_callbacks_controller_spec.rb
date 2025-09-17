# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GitHub OAuth' do
    let(:github_auth) do
      OmniAuth::AuthHash.new({
        provider: 'github',
        uid: '123456',
        info: {
          email: 'test@example.com',
          name: 'Test User',
          first_name: 'Test',
          last_name: 'User'
        }
      })
    end

    before do
      request.env['omniauth.auth'] = github_auth
    end

    context 'when user does not exist' do
      it 'creates a new user and signs them in' do
        expect {
          get :github
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.name).to eq('Test User')
        expect(user.provider).to eq('github')
        expect(user.uid).to eq('123456')
        expect(response).to be_redirect
      end
    end

    context 'when user already exists' do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it 'signs in the existing user' do
        expect {
          get :github
        }.not_to change(User, :count)

        expect(response).to be_redirect
      end
    end
  end

  describe 'Google OAuth' do
    let(:google_auth) do
      OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '789012',
        info: {
          email: 'google@example.com',
          name: 'Google User',
          first_name: 'Google',
          last_name: 'User'
        }
      })
    end

    before do
      request.env['omniauth.auth'] = google_auth
    end

    it 'creates a new user and signs them in' do
      expect {
        get :google_oauth2
      }.to change(User, :count).by(1)

      user = User.last
      expect(user.email).to eq('google@example.com')
      expect(user.name).to eq('Google User')
      expect(user.provider).to eq('google_oauth2')
      expect(user.uid).to eq('789012')
      expect(response).to be_redirect
    end
  end

  describe '#failure' do
    it 'has failure method defined' do
      expect(controller).to respond_to(:failure)
    end
  end
end
