require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'test@example.com', password: 'password')
    post = Post.create(title: 'Test Post', text: 'Test Content', user_id: user.id)
    comment = Comment.new(text: 'Test Comment', user: user, post: post)
    expect(comment).to be_valid
  end

  it 'is not valid without content' do
    user = User.create(email: 'test@example.com', password: 'password')
    post = Post.create(title: 'Test Post', text: 'Test Content', user_id: user.id)
    comment = Comment.new(text: nil, user: user, post: post)
    expect(comment).to_not be_valid
  end
end
