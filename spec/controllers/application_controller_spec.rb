require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello, world!'
    end

    def raise_exception
      raise StandardError, 'An error occurred'
    end
  end

  before do
    routes.draw do
      get 'index', to: 'anonymous#index'
      get 'raise_exception', to: 'anonymous#raise_exception'
    end
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "renders the correct text" do
      get :index
      expect(response.body).to eq('Hello, world!')
    end
  end

  describe "Exception Handling" do
    it "rescues from StandardError and renders a 500 error page" do
      get :raise_exception
      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include('We\'re sorry, but something went wrong.')
    end
  end
end
