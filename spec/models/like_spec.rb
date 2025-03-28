require 'rails_helper'

RSpec.describe Like, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'test@example.com', password: 'password')
    post = Post.create(title: 'Test Post', text: 'Test Content', user_id: user.id)
    like = Like.new(user: user, post: post)
    expect(like).to be_valid
  end

  it 'is not valid without a user' do
    user = User.create(email: 'test@example.com', password: 'password')
    post = Post.create(title: 'Test Post', text: 'Test Content', user_id: user.id)
    like = Like.new(user: nil, post: post)
    expect(like).to_not be_valid
  end

  it 'is not valid without a post' do
    user = User.create(email: 'test@example.com', password: 'password')
    post = Post.create(title: 'Test Post', text: 'Test Content', user_id: user.id)
    like = Like.new(user: user, post: nil)
    expect(like).to_not be_valid
  end
end
