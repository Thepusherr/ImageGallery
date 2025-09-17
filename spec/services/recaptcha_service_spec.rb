# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecaptchaService, type: :service do
  let(:request) { double('request', remote_ip: '127.0.0.1') }
  let(:service) { described_class.new(request) }
  let(:email) { 'test@example.com' }

  describe '#recaptcha_required_for_login?' do
    context 'when IP is blocked' do
      before do
        allow(FailedLoginAttempt).to receive(:blocked?).with('127.0.0.1', email).and_return(true)
      end

      it 'returns true' do
        expect(service.recaptcha_required_for_login?(email)).to be true
      end
    end

    context 'when there are 3 or more recent failed attempts' do
      before do
        allow(FailedLoginAttempt).to receive(:blocked?).with('127.0.0.1', email).and_return(false)
        allow(service).to receive(:recent_failed_attempts_count).with(email).and_return(3)
      end

      it 'returns true' do
        expect(service.recaptcha_required_for_login?(email)).to be true
      end
    end

    context 'when there are fewer than 3 recent failed attempts' do
      before do
        allow(FailedLoginAttempt).to receive(:blocked?).with('127.0.0.1', email).and_return(false)
        allow(service).to receive(:recent_failed_attempts_count).with(email).and_return(2)
      end

      it 'returns false' do
        expect(service.recaptcha_required_for_login?(email)).to be false
      end
    end
  end

  describe '#recaptcha_required_for_comment?' do
    let(:user) { create(:user) }

    context 'when user is nil' do
      it 'returns false' do
        expect(service.recaptcha_required_for_comment?(nil)).to be false
      end
    end

    context 'when user has posted 3 or more comments in last 10 minutes' do
      before do
        allow(user.comments).to receive_message_chain(:where, :count).and_return(3)
      end

      it 'returns true' do
        expect(service.recaptcha_required_for_comment?(user)).to be true
      end
    end

    context 'when user has posted fewer than 3 comments in last 10 minutes' do
      before do
        allow(user.comments).to receive_message_chain(:where, :count).and_return(2)
      end

      it 'returns false' do
        expect(service.recaptcha_required_for_comment?(user)).to be false
      end
    end
  end

  describe '#record_failed_login' do
    it 'records failed login attempt' do
      expect(FailedLoginAttempt).to receive(:record_failure).with('127.0.0.1', email)
      service.record_failed_login(email)
    end
  end

  describe '#clear_failed_attempts' do
    it 'clears failed attempts' do
      expect(FailedLoginAttempt).to receive(:clear_attempts).with('127.0.0.1', email)
      service.clear_failed_attempts(email)
    end
  end

  describe '#blocked?' do
    it 'checks if IP/email is blocked' do
      expect(FailedLoginAttempt).to receive(:blocked?).with('127.0.0.1', email)
      service.blocked?(email)
    end
  end
end
