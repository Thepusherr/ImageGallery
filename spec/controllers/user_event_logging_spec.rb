# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Event Logging', type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe LikesController do
    describe 'POST #create' do
      it 'creates a like successfully' do
        expect {
          post :create, params: { post_id: post_obj.id }
        }.to change(Like, :count).by(1)

        expect(response).to redirect_to(post_path(post_obj))
        expect(Like.where(post: post_obj, user: user)).to exist
      end
    end

    describe 'DELETE #destroy' do
      let!(:like) { create(:like, post: post_obj, user: user) }

      it 'destroys a like successfully' do
        expect {
          delete :destroy, params: { id: like.id }
        }.to change(Like, :count).by(-1)

        expect(response).to redirect_to(post_path(post_obj))
        expect(Like.where(id: like.id)).not_to exist
      end
    end
  end

  describe CommentsController do
    describe 'POST #create' do
      it 'creates a comment successfully' do
        expect {
          post :create, params: { post_id: post_obj.id, text: 'Test comment' }
        }.to change(Comment, :count).by(1)

        comment = Comment.last
        expect(comment.text).to eq('Test comment')
        expect(comment.user).to eq(user)
        expect(comment.post).to eq(post_obj)
      end
    end
  end
end
