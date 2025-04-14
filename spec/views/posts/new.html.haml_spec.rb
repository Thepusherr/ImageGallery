require 'rails_helper'

RSpec.describe "posts/new", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    assign(:post, Post.new(user: user, title: "", text: ""))
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", posts_path, "post" do
    end
  end
end
