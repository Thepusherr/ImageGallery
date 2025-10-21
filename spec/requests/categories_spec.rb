require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /show" do
    it "returns http success" do
      user = FactoryBot.create(:user)
      category = Category.create!(name: "Test Category", user: user)
      
      get "/categories/#{category.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
