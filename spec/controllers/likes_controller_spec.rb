require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post) }

  describe "POST #create" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "redirects to the post show page" do
        post :create, params: { post_id: post_obj.id }
        expect(response).to redirect_to(post_path(post_obj))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { post_id: post_obj.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
