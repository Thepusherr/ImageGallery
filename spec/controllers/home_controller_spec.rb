require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get :contact
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #services" do
    it "returns http success" do
      get :services
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #gallery" do
    it "returns http success" do
      get :gallery
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #gallery_single" do
    it "returns http success" do
      get :gallery_single
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #main" do
    it "returns http success" do
      get :main
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #starter_page" do
    it "returns http success" do
      get :starter_page
      expect(response).to have_http_status(:success)
    end
  end
end
