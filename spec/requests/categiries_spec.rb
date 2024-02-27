require 'rails_helper'

RSpec.describe "Categiries", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/categiries/show"
      expect(response).to have_http_status(:success)
    end
  end

end
