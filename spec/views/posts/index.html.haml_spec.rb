require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    
    assign(:posts, [
      Post.create!(user: user, title: "Test Post 1", text: "Test content 1"),
      Post.create!(user: user, title: "Test Post 2", text: "Test content 2")
    ])
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders a list of posts" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
