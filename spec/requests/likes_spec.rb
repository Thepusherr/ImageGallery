require 'rails_helper'

RSpec.describe "/likes", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Like. As you add validations to Like, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Like.create! valid_attributes
      get likes_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      like = Like.create! valid_attributes
      get like_url(like)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_like_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      like = Like.create! valid_attributes
      get edit_like_url(like)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Like" do
        expect {
          post likes_url, params: { like: valid_attributes }
        }.to change(Like, :count).by(1)
      end

      it "redirects to the created like" do
        post likes_url, params: { like: valid_attributes }
        expect(response).to redirect_to(like_url(Like.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Like" do
        expect {
          post likes_url, params: { like: invalid_attributes }
        }.to change(Like, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post likes_url, params: { like: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested like" do
        like = Like.create! valid_attributes
        patch like_url(like), params: { like: new_attributes }
        like.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the like" do
        like = Like.create! valid_attributes
        patch like_url(like), params: { like: new_attributes }
        like.reload
        expect(response).to redirect_to(like_url(like))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        like = Like.create! valid_attributes
        patch like_url(like), params: { like: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested like" do
      like = Like.create! valid_attributes
      expect {
        delete like_url(like)
      }.to change(Like, :count).by(-1)
    end

    it "redirects to the likes list" do
      like = Like.create! valid_attributes
      delete like_url(like)
      expect(response).to redirect_to(likes_url)
    end
  end
end
