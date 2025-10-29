# frozen_string_literal: true

require 'spec_helper'

describe UserEventLogger do
  before do
    UserEventLogger.reset_calls if UserEventLogger.respond_to?(:reset_calls)
  end

  it 'responds to log' do
    expect(UserEventLogger).to respond_to(:log)
  end

  it 'logs navigation events' do
    expect do
      UserEventLogger.log_navigation(user: 'test_user', url: '/test')
    end.not_to raise_error
  end

  it 'logs general events' do
    expect do
      UserEventLogger.log(user: 'test_user', action_type: 'test', url: '/test')
    end.not_to raise_error
  end

  it 'handles unknown methods' do
    expect do
      UserEventLogger.unknown_method(param1: 'value1', param2: 'value2')
    end.not_to raise_error
  end
end
