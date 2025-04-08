# Основная конфигурация Devise находится в rails_helper.rb и devise_config.rb
# Этот файл содержит дополнительные настройки для специфических сценариев тестирования

# Метод для быстрого создания и входа пользователя с определенными атрибутами
def create_logged_in_user(attributes = {})
  user = create(:user, attributes)
  if defined?(controller)
    sign_in user
  else
    login_as(user, scope: :user)
  end
  user
end

# Добавляем метод в глобальное пространство имен RSpec
RSpec.configure do |config|
  config.include Module.new {
    def create_logged_in_user(attributes = {})
      user = create(:user, attributes)
      if respond_to?(:sign_in)
        sign_in user
      elsif respond_to?(:login_as)
        login_as user, scope: :user
      end
      user
    end
  }
end# Основная конфигурация Devise находится в rails_helper.rb и devise_config.rb
# Этот файл содержит дополнительные настройки для специфических сценариев тестирования

# Метод для быстрого создания и входа пользователя с определенными атрибутами
def create_logged_in_user(attributes = {})
  user = create(:user, attributes)
  if defined?(controller)
    sign_in user
  else
    login_as(user, scope: :user)
  end
  user
end

# Добавляем метод в глобальное пространство имен RSpec
RSpec.configure do |config|
  config.include Module.new {
    def create_logged_in_user(attributes = {})
      user = create(:user, attributes)
      if respond_to?(:sign_in)
        sign_in user
      elsif respond_to?(:login_as)
        login_as user, scope: :user
      end
      user
    end
  }
end