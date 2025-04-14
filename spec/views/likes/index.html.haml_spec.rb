require 'rails_helper'

RSpec.describe "likes/index", type: :view do
  before(:each) do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    post1 = FactoryBot.create(:post, user: user1)
    post2 = FactoryBot.create(:post, user: user2)
    
    assign(:likes, [
      Like.create!(user: user1, post: post1),
      Like.create!(user: user2, post: post2)
    ])
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user1)
  end

  it "renders a list of likes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
