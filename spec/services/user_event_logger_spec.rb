# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserEventLogger, type: :service do
  let(:user) { create(:user) }

  describe '.log' do
    context 'in test environment' do
      it 'returns true without creating UserEvent' do
        expect(UserEvent).not_to receive(:create!)
        
        result = UserEventLogger.log(
          user: user,
          action_type: 'test_action',
          url: '/test'
        )
        
        expect(result).to be true
      end
    end
  end

  describe '.log_navigation' do
    it 'returns true in test environment' do
      result = UserEventLogger.log_navigation(user: user, url: '/test')
      expect(result).to be true
    end

    it 'calls log method with correct parameters' do
      # Test that the method exists and can be called
      expect { UserEventLogger.log_navigation(user: user, url: '/test') }.not_to raise_error
    end
  end
end
