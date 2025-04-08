# Стандартная конфигурация Devise для тестов
# Этот файл содержит все необходимые настройки для работы с аутентификацией в тестах

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
  # Включаем хелперы для request-спеков
  config.include DeviseRequestSpecHelpers, type: :request
  
  # Настройка маппингов Devise для тестов
  config.before(:each, type: :controller) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  config.before(:each, type: :request) do
    # Ничего дополнительного не требуется, так как используем login_as
  end
end# Стандартная конфигурация Devise для тестов
# Этот файл содержит все необходимые настройки для работы с аутентификацией в тестах

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
  # Включаем хелперы для request-спеков
  config.include DeviseRequestSpecHelpers, type: :request
  
  # Настройка маппингов Devise для тестов
  config.before(:each, type: :controller) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  config.before(:each, type: :request) do
    # Ничего дополнительного не требуется, так как используем login_as
  end
end