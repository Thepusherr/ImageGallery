require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /show" do
    it "returns http success" do
      # Создаем пользователя для категории
      user = FactoryBot.create(:user)
      
      # Создаем категорию для теста
      category = Category.create!(name: "Test Category", user: user)
      
      # Используем правильный путь с ID категории
      get "/categories/#{category.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
