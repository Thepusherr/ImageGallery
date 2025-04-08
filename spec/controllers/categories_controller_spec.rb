require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:other_user) { create(:user, email: "other_user@example.com") }
  let(:other_category) { create(:category, user: other_user) }

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

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns visible categories to @categories" do
        visible_category = create(:category, user: user)
        hidden_category = create(:category, :hidden, user: user)
        
        get :index
        expect(assigns(:categories)).to include(visible_category)
        expect(assigns(:categories)).not_to include(hidden_category)
      end
    end

    context "when user is not signed in" do
      it "returns a successful response" do
        get :index
        expect(response).to be_successful
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
        get :show, params: { id: category.id }
        expect(response).to be_successful
      end

      it "renders the show template" do
        get :show, params: { id: category.id }
        expect(response).to render_template(:show)
      end

      context "with visible category" do
        it "assigns the requested category to @category" do
          get :show, params: { id: category.id }
          expect(assigns(:category)).to eq(category)
        end
      end

      context "with hidden category" do
        let(:hidden_category) { create(:category, :hidden, user: user) }
        
        it "assigns the requested category to @category when owner" do
          get :show, params: { id: hidden_category.id }
          expect(assigns(:category)).to eq(hidden_category)
        end

        it "redirects with unauthorized alert when not owner" do
          hidden_category.update!(user: other_user)
          get :show, params: { id: hidden_category.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end
    end

    context "when user is not signed in" do
      it "returns a successful response for visible category" do
        get :show, params: { id: category.id }
        expect(response).to be_successful
      end

      it "redirects with unauthorized alert for hidden category" do
        hidden_category = create(:category, :hidden, user: user)
        get :show, params: { id: hidden_category.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #new" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

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
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      context "with valid parameters" do
        it "creates a new category" do
          expect {
            post :create, params: { category: { name: "New Category" } }
          }.to change(Category, :count).by(1)
        end

        it "redirects to the created category" do
          post :create, params: { category: { name: "New Category" } }
          expect(response).to redirect_to(category_path(Category.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new category" do
          expect {
            post :create, params: { category: { name: "" } }
          }.not_to change(Category, :count)
        end

        it "renders the new template" do
          post :create, params: { category: { name: "" } }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { category: { name: "New Category" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

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
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

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
          original_name = category.name
          patch :update, params: { id: category.id, category: { name: "" } }
          category.reload
          expect(category.name).to eq(original_name)
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
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it "destroys the requested category" do
        category # ensure category is created before the expect block
        expect {
          delete :destroy, params: { id: category.id }
        }.to change(Category, :count).by(-1)
      end

      it "redirects to the categories list" do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(categories_url)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show_image" do
    let(:post_with_image) do
      post = create(:post, user: user)
      post.categories << category
      
      # Ensure the post has an image attached
      unless post.image.attached?
        file_path = Rails.root.join('spec/fixtures/test_image.jpg')
        post.image.attach(io: File.open(file_path), filename: 'test_image.jpg', content_type: 'image/jpeg')
      end
      
      post
    end

    context "when user is signed in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        # Make sure post is created and associated with category
        post_with_image
      end

      it "returns a successful response" do
        get :show_image, params: { id: category.id, image_index: 1 }
        expect(response).to be_successful
      end

      it "assigns posts with images" do
        get :show_image, params: { id: category.id, image_index: 1 }
        expect(assigns(:posts_with_images)).to include(post_with_image)
      end
    end

    context "invalid image index" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        # Ensure post_with_image is created to avoid empty posts_with_images array
        post_with_image
      end
      
      it "redirects with alert" do
        invalid_index = 999
        get :show_image, params: { id: category.id, image_index: invalid_index }
        expect(response).to redirect_to(category_path(category))
        expect(flash[:alert]).to be_present
      end
    end
  end
end
