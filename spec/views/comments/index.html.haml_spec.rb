require 'rails_helper'

RSpec.describe "comments/index", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    post_obj = FactoryBot.create(:post, user: user)
    
    assign(:comments, [
      Comment.create!(user: user, post: post_obj, text: "Test comment 1"),
      Comment.create!(user: user, post: post_obj, text: "Test comment 2")
    ])
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders a list of comments" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
