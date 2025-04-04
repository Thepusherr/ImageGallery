require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe "POST #create" do
    context "when user is signed in" do
      before { sign_in user }

      it "creates a new like" do
        expect {
          post :create, params: { post_id: post.id }
        }.to change(Like, :count).by(1)
      end

      it "redirects to the post show page" do
        post :create, params: { post_id: post.id }
        expect(response).to redirect_to(post_path(post))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { post_id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:like) { create(:like, user: user, post: post) }

    context "when user is signed in" do
      before { sign_in user }

      it "destroys the like" do
        expect {
          delete :destroy, params: { id: like.id }
        }.to change(Like, :count).by(-1)
      end

      it "redirects to the post show page" do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to(post_path(post))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
