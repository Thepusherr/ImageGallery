require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    @post = Post.create!(user: user, title: "Test Post", text: "Test content")
    assign(:post, @post)
    
    # Создаем комментарий для формы
    @comment = Comment.new(post: @post)
    assign(:comment, @comment)
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders attributes in <p>" do
    render
  end
end
