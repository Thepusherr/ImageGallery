# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:auth) do
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

    context 'when user does not exist' do
      it 'creates a new user' do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.name).to eq('Test User')
        expect(user.surname).to eq('User')
        expect(user.provider).to eq('github')
        expect(user.uid).to eq('123456')
        expect(user.username).to eq('test')
      end

      it 'generates unique username when email username is taken' do
        create(:user, username: 'test')
        
        user = User.from_omniauth(auth)
        expect(user.username).to eq('test1')
      end
    end

    context 'when user already exists' do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it 'returns the existing user' do
        expect {
          User.from_omniauth(auth)
        }.not_to change(User, :count)

        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end

    context 'with minimal auth info' do
      let(:minimal_auth) do
        OmniAuth::AuthHash.new({
          provider: 'github',
          uid: '789012',
          info: {
            email: 'minimal@example.com',
            name: nil,
            first_name: nil,
            last_name: nil
          }
        })
      end

      it 'creates user with default values' do
        user = User.from_omniauth(minimal_auth)

        expect(user.email).to eq('minimal@example.com')
        expect(user.name).to eq('User')
        expect(user.surname).to eq('Surname')
        expect(user.username).to eq('minimal')
      end
    end
  end

  describe '.generate_username_from_email' do
    it 'generates username from email' do
      username = User.generate_username_from_email('test.user@example.com')
      expect(username).to eq('testuser')
    end

    it 'handles special characters' do
      username = User.generate_username_from_email('test-user+tag@example.com')
      expect(username).to eq('testusertag')
    end

    it 'generates unique username when base is taken' do
      create(:user, username: 'testuser')
      
      username = User.generate_username_from_email('test.user@example.com')
      expect(username).to eq('testuser1')
    end

    it 'increments counter for multiple conflicts' do
      create(:user, username: 'testuser')
      create(:user, username: 'testuser1')
      
      username = User.generate_username_from_email('test.user@example.com')
      expect(username).to eq('testuser2')
    end
  end
end
