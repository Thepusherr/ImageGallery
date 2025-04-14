require 'rails_helper'

RSpec.describe "posts/edit", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:post) {
    Post.create!(user: user, title: "Test Post", text: "Test content")
  }

  before(:each) do
    assign(:post, post)
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(post), "post" do
    end
  end
end
