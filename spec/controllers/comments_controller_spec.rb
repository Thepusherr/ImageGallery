require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }

  describe "POST #create" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "creates a new comment" do
        expect {
          post :create, params: { post_id: post_obj.id, comment: { text: "Great post!" } }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the post show page" do
        post :create, params: { post_id: post_obj.id, comment: { text: "Great post!" } }
        expect(response).to redirect_to(post_path(post_obj))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { post_id: post_obj.id, comment: { text: "Great post!" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, user: user, post: post_obj) }

    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "destroys the comment" do
        expect {
          delete :destroy, params: { id: comment.id }
        }.to change(Comment, :count).by(-1)
      end

      it "redirects to the post show page" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to(post_path(post_obj))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
