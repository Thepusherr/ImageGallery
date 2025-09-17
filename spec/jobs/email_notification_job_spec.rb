# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailNotificationJob, type: :job do
  describe '#perform' do
    let(:email) { 'test@example.com' }
    let(:data) { { user_name: 'Test User' } }

    it 'sends welcome email' do
      expect(Rails.logger).to receive(:info).with("Sending welcome email to #{email}")
      expect(Rails.logger).to receive(:info).with("Welcome email sent to #{email} for user: Test User")
      
      described_class.perform_now('welcome', email, data)
    end

    it 'sends new comment email' do
      comment_data = {
        post_title: 'Test Post',
        commenter_name: 'John Doe',
        comment_text: 'Great post!'
      }
      
      expect(Rails.logger).to receive(:info).with("Sending new comment notification to #{email}")
      expect(Rails.logger).to receive(:info).with("Comment on post 'Test Post' by John Doe: Great post!")
      
      described_class.perform_now('new_comment', email, comment_data)
    end

    it 'sends new like email' do
      like_data = {
        post_title: 'Test Post',
        liker_name: 'Jane Doe'
      }
      
      expect(Rails.logger).to receive(:info).with("Sending new like notification to #{email}")
      expect(Rails.logger).to receive(:info).with("Jane Doe liked your post 'Test Post'")
      
      described_class.perform_now('new_like', email, like_data)
    end

    it 'handles unknown notification type' do
      expect(Rails.logger).to receive(:error).with("Unknown notification type: unknown")
      
      described_class.perform_now('unknown', email, data)
    end

    it 'handles errors gracefully' do
      allow(Rails.logger).to receive(:info).and_raise(StandardError.new('Test error'))
      
      expect { described_class.perform_now('welcome', email, data) }.to raise_error(StandardError, 'Test error')
    end
  end
end
