require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:other_user) { create(:user, email: "other_user@example.com") }
  let(:other_category) { create(:category, user: other_user) }

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

      it "assigns @categories" do
        get :index
        expect(assigns(:categories)).to eq(Category.all)
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
        get :show, params: { id: category.id }
        expect(response).to be_successful
      end

      it "renders the show template" do
        get :show, params: { id: category.id }
        expect(response).to render_template(:show)
      end

      it "assigns the requested category to @category" do
        get :show, params: { id: category.id }
        expect(assigns(:category)).to eq(category)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :show, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #new" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns a new category to @category" do
        get :new
        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is signed in" do
      before { sign_in user }

      context "with valid parameters" do
        it "creates a new category" do
          expect {
            post :create, params: { category: { name: "New Category", description: "This is a new category" } }
          }.to change(Category, :count).by(1)
        end

        it "redirects to the created category" do
          post :create, params: { category: { name: "New Category", description: "This is a new category" } }
          expect(response).to redirect_to(category_path(Category.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new category" do
          expect {
            post :create, params: { category: { name: "", description: "This is a new category" } }
          }.not_to change(Category, :count)
        end

        it "renders the new template" do
          post :create, params: { category: { name: "", description: "This is a new category" } }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { category: { name: "New Category", description: "This is a new category" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get :edit, params: { id: category.id }
        expect(response).to be_successful
      end

      it "renders the edit template" do
        get :edit, params: { id: category.id }
        expect(response).to render_template(:edit)
      end

      it "assigns the requested category to @category" do
        get :edit, params: { id: category.id }
        expect(assigns(:category)).to eq(category)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :edit, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is signed in" do
      before { sign_in user }

      context "with valid parameters" do
        it "updates the requested category" do
          patch :update, params: { id: category.id, category: { name: "Updated Category" } }
          category.reload
          expect(category.name).to eq("Updated Category")
        end

        it "redirects to the category" do
          patch :update, params: { id: category.id, category: { name: "Updated Category" } }
          expect(response).to redirect_to(category_path(category))
        end
      end

      context "with invalid parameters" do
        it "does not update the requested category" do
          patch :update, params: { id: category.id, category: { name: "" } }
          category.reload
          expect(category.name).not_to eq("")
        end

        it "renders the edit template" do
          patch :update, params: { id: category.id, category: { name: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        patch :update, params: { id: category.id, category: { name: "Updated Category" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is signed in" do
      before { sign_in user }

      it "destroys the requested category" do
        expect {
          delete :destroy, params: { id: category.id }
        }.to change(Category, :count).by(-1)
      end

      it "redirects to the categories list" do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
