def create_logged_in_user(attributes = {})
  user = create(:user, attributes)
  if defined?(controller)
    sign_in user
  else
    login_as(user, scope: :user)
  end
  user
end

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

def create_logged_in_user(attributes = {})
  user = create(:user, attributes)
  if defined?(controller)
    sign_in user
  else
    login_as(user, scope: :user)
  end
  user
end

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