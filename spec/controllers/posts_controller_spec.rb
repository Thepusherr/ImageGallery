require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @posts" do
      get :index
      expect(assigns(:posts)).to include(post_obj)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: post_obj.id }
      expect(response).to be_successful
    end

    it "renders the show template" do
      get :show, params: { id: post_obj.id }
      expect(response).to render_template(:show)
    end

    it "assigns the requested post to @post" do
      get :show, params: { id: post_obj.id }
      expect(assigns(:post)).to eq(post_obj)
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

      it "assigns a new post to @post" do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
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
        it "creates a new post" do
          expect {
            post :create, params: { post: { title: "New Post", text: "This is a new post" } }
          }.to change(Post, :count).by(1)
        end

        it "redirects to the created post" do
          post :create, params: { post: { title: "New Post", text: "This is a new post" } }
          expect(response).to redirect_to(post_path(Post.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new post" do
          expect {
            post :create, params: { post: { title: "", text: "This is a new post" } }
          }.not_to change(Post, :count)
        end

        it "renders the new template" do
          post :create, params: { post: { title: "", text: "This is a new post" } }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        post :create, params: { post: { title: "New Post", text: "This is a new post" } }
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
        get :edit, params: { id: post_obj.id }
        expect(response).to be_successful
      end

      it "renders the edit template" do
        get :edit, params: { id: post_obj.id }
        expect(response).to render_template(:edit)
      end

      it "assigns the requested post to @post" do
        get :edit, params: { id: post_obj.id }
        expect(assigns(:post)).to eq(post_obj)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        get :edit, params: { id: post_obj.id }
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
        it "updates the requested post" do
          patch :update, params: { id: post_obj.id, post: { title: "Updated Post" } }
          post_obj.reload
          expect(post_obj.title).to eq("Updated Post")
        end

        it "redirects to the post" do
          patch :update, params: { id: post_obj.id, post: { title: "Updated Post" } }
          expect(response).to redirect_to(post_path(post_obj))
        end
      end

      context "with invalid parameters" do
        it "does not update the requested post" do
          patch :update, params: { id: post_obj.id, post: { title: "" } }
          post_obj.reload
          expect(post_obj.title).not_to eq("")
        end

        it "renders the edit template" do
          patch :update, params: { id: post_obj.id, post: { title: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        patch :update, params: { id: post_obj.id, post: { title: "Updated Post" } }
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

      it "destroys the requested post" do
        post_to_delete = create(:post, user: user)
        expect {
          delete :destroy, params: { id: post_to_delete.id }
        }.to change(Post, :count).by(-1)
      end

      it "redirects to the posts list" do
        delete :destroy, params: { id: post_obj.id }
        expect(response).to redirect_to(posts_path)
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: post_obj.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
