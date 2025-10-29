# frozen_string_literal: true

module DeviseRequestSpecHelpers
  include Warden::Test::Helpers

  def sign_in(resource_or_scope, resource = nil)
    resource ||= resource_or_scope
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    login_as(resource, scope: scope)
  end

  def sign_out(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    logout(scope)
  end
end

RSpec.configure do |config|
  config.include DeviseRequestSpecHelpers, type: :request

  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  config.before(:each, type: :request) do
  end
end

module DeviseRequestSpecHelpers
  include Warden::Test::Helpers

  def sign_in(resource_or_scope, resource = nil)
    resource ||= resource_or_scope
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    login_as(resource, scope: scope)
  end

  def sign_out(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    logout(scope)
  end
end

RSpec.configure do |config|
  config.include DeviseRequestSpecHelpers, type: :request

  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  config.before(:each, type: :request) do
  end
end
