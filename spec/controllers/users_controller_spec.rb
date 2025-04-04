require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other_user@example.com") }

  describe "GET #index" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns @users" do
        get :index
        expect(assigns(:users)).to eq(User.all)
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

  describe "GET #edit" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get :edit, params: { id: user.id }
        expect(response).to be_successful
      end

      it "renders the edit template" do
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end

      it "assigns the requested user to @user" do
        get :edit, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is signed in" do
      before { sign_in user }

      context "with valid parameters" do
        it "updates the requested user" do
          patch :update, params: { id: user.id, user: { name: "Updated Name" } }
          user.reload
          expect(user.name).to eq("Updated Name")
        end

        it "redirects to the user" do
          patch :update, params: { id: user.id, user: { name: "Updated Name" } }
          expect(response).to redirect_to(user_path(user))
        end
      end

      context "with invalid parameters" do
        it "does not update the requested user" do
          patch :update, params: { id: user.id, user: { name: "" } }
          user.reload
          expect(user.name).not_to eq("")
        end

        it "renders the edit template" do
          patch :update, params: { id: user.id, user: { name: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        patch :update, params: { id: user.id, user: { name: "Updated Name" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is signed in" do
      before { sign_in user }

      it "destroys the requested user" do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(users_path)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
