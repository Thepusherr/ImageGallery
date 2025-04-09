require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  describe "POST #create" do
    context "when user is signed in" do
      before do
        sign_in user
      end

      it "creates a new subscription" do
        expect {
          post :create, params: { category_id: category.id }
        }.to change(Subscription, :count).by(1)
      end

      it "redirects to the category page" do
        post :create, params: { category_id: category.id }
        expect(response).to redirect_to(category_path(category))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { category_id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is signed in and subscribed" do
      before do
        sign_in user
        create(:subscription, user: user, category: category)
      end

      it "destroys the subscription" do
        expect {
          delete :destroy, params: { category_id: category.id }
        }.to change(Subscription, :count).by(-1)
      end

      it "redirects to the category page" do
        delete :destroy, params: { category_id: category.id }
        expect(response).to redirect_to(category_path(category))
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { category_id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end