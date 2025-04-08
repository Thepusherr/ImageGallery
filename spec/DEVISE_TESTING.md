# Настройка тестирования с Devise

## Общая информация

Для правильной работы тестов с Devise в проекте используется следующая конфигурация:

1. Основная настройка в `rails_helper.rb`
2. Дополнительные хелперы в `spec/support/devise_config.rb`
3. Удобные методы для аутентификации в `spec/support/auth_helper.rb`

## Как использовать в тестах контроллеров

Для тестирования контроллеров с аутентификацией используйте следующий паттерн:

```ruby
describe "POST #create" do
  context "when user is signed in" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    
    it "creates a new resource" do
      # тест с аутентификацией
    end
  end
  
  context "when user is not signed in" do
    it "redirects to the sign-in page" do
      # тест без аутентификации
    end
  end
end
```

## Как использовать в интеграционных тестах

Для интеграционных тестов (request, feature, system) используйте:

```ruby
describe "POST /resources" do
  context "when user is signed in" do
    before do
      login_as user, scope: :user
    end
    
    it "creates a new resource" do
      # тест с аутентификацией
    end
  end
  
  context "when user is not signed in" do
    it "redirects to the sign-in page" do
      # тест без аутентификации
    end
  end
end
```

## Удобные хелперы

В проекте есть несколько удобных хелперов для работы с аутентификацией:

1. `sign_in_user` - для тестов контроллеров
2. `login_as_user` - для интеграционных тестов
3. `create_logged_in_user` - универсальный метод, который работает в любом типе тестов

## Решение проблем

Если возникают проблемы с аутентификацией в тестах:

1. Убедитесь, что вы добавили `@request.env["devise.mapping"] = Devise.mappings[:user]` в тестах контроллеров
2. Проверьте, что вы используете `sign_in` для тестов контроллеров и `login_as` для интеграционных тестов
3. Убедитесь, что вы вызываете `Warden.test_mode!` перед тестами и `Warden.test_reset!` после тестов

## Дополнительные ресурсы

- [Официальная документация Devise](https://github.com/heartcombo/devise#test-helpers)
- [RSpec и Devise](https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec))# Настройка тестирования с Devise

## Общая информация

Для правильной работы тестов с Devise в проекте используется следующая конфигурация:

1. Основная настройка в `rails_helper.rb`
2. Дополнительные хелперы в `spec/support/devise_config.rb`
3. Удобные методы для аутентификации в `spec/support/auth_helper.rb`

## Как использовать в тестах контроллеров

Для тестирования контроллеров с аутентификацией используйте следующий паттерн:

```ruby
describe "POST #create" do
  context "when user is signed in" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    
    it "creates a new resource" do
      # тест с аутентификацией
    end
  end
  
  context "when user is not signed in" do
    it "redirects to the sign-in page" do
      # тест без аутентификации
    end
  end
end
```

## Как использовать в интеграционных тестах

Для интеграционных тестов (request, feature, system) используйте:

```ruby
describe "POST /resources" do
  context "when user is signed in" do
    before do
      login_as user, scope: :user
    end
    
    it "creates a new resource" do
      # тест с аутентификацией
    end
  end
  
  context "when user is not signed in" do
    it "redirects to the sign-in page" do
      # тест без аутентификации
    end
  end
end
```

## Удобные хелперы

В проекте есть несколько удобных хелперов для работы с аутентификацией:

1. `sign_in_user` - для тестов контроллеров
2. `login_as_user` - для интеграционных тестов
3. `create_logged_in_user` - универсальный метод, который работает в любом типе тестов

## Решение проблем

Если возникают проблемы с аутентификацией в тестах:

1. Убедитесь, что вы добавили `@request.env["devise.mapping"] = Devise.mappings[:user]` в тестах контроллеров
2. Проверьте, что вы используете `sign_in` для тестов контроллеров и `login_as` для интеграционных тестов
3. Убедитесь, что вы вызываете `Warden.test_mode!` перед тестами и `Warden.test_reset!` после тестов

## Дополнительные ресурсы

- [Официальная документация Devise](https://github.com/heartcombo/devise#test-helpers)
- [RSpec и Devise](https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec))