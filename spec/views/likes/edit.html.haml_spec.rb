require 'rails_helper'

RSpec.describe "likes/edit", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:post_obj) { FactoryBot.create(:post, user: user) }
  let(:like) {
    Like.create!(user: user, post: post_obj)
  }

  before(:each) do
    assign(:like, like)
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders the edit like form" do
    render

    assert_select "form[action=?][method=?]", like_path(like), "post" do
    end
  end
end
