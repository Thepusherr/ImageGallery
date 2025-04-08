require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "returns a successful response" do
        get :show, params: { id: user.id }
        expect(response).to be_successful
      end
    end
  end
end
