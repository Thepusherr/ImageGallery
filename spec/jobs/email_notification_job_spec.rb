# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailNotificationJob, type: :job do
  describe '#perform' do
    let(:email) { 'test@example.com' }
    let(:data) { { user_name: 'Test User' } }

    it 'sends welcome email' do
      expect { described_class.perform_now('welcome', email, data) }.not_to raise_error
    end

    it 'sends new comment email' do
      comment_data = {
        post_title: 'Test Post',
        commenter_name: 'John Doe',
        comment_text: 'Great post!'
      }

      expect { described_class.perform_now('new_comment', email, comment_data) }.not_to raise_error
    end

    it 'sends new like email' do
      like_data = {
        post_title: 'Test Post',
        liker_name: 'Jane Doe'
      }

      expect { described_class.perform_now('new_like', email, like_data) }.not_to raise_error
    end

    it 'handles unknown notification type' do
      expect { described_class.perform_now('unknown', email, data) }.not_to raise_error
    end

    it 'handles errors gracefully' do
      allow_any_instance_of(EmailNotificationJob).to receive(:send_welcome_email).and_raise(StandardError.new('Test error'))

      expect { described_class.perform_now('welcome', email, data) }.to raise_error(StandardError, 'Test error')
    end
  end
end
