# Authentication helper for tests
# This file provides additional helper methods for authentication in tests

# This file provides additional helper methods for authentication in tests

module AuthHelper
  # Sign in a user for controller tests
  def sign_in_user(user = nil)
    user ||= create(:user)
    sign_    user
  end

  # Sign in a user for feature/system tests
  def login_as_user(user = nil)
    user ||= create(:user)
    login_as(user, scope: :user)
    user
  end
  
  # Create and sign in a user for any test type
  def create_and_sign_in_user
    user = create(:user)
    if respond_to?(:sign_in)
      sign_in user
    elsif respond_to?(:login_as)
      login_as user, scope: :user
    end
    user
  end
  
  # Create and sign in a user for any test type
  def create_and_sign_in_user
    user = create(:user)
    if respond_to?(:sign_in)
      sign_in user
    elsif respond_to?(:login_as)
      login_as user, scope: :user
    end
    user
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :controller
  config.include AuthHelper, type: :request
  config.include AuthHelper, type: :feature
  config.include AuthHelper, type: :system
end