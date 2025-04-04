require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #show" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get :show, params: { id: user.id }
        expect(response).to be_successful
      end

      it "renders the show template" do
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end

      it "assigns the requested user to @user" do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
