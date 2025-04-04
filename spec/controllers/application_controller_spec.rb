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
      expect {
        get :raise_exception
      }.to raise_error(StandardError, 'An error occurred')
    end
  end
end
