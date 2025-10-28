require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    @post = Post.create!(user: user, title: "Test Post", text: "Test content")
    assign(:post, @post)
    
    @comment = Comment.new(post: @post)
    assign(:comment, @comment)
    
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders attributes in <p>" do
    render
  end
end
