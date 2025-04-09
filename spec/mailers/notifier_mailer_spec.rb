require "rails_helper"

RSpec.describe NotifierMailer, type: :mailer do
  describe "category_subscription" do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let(:mail) { NotifierMailer.category_subscription(user, category) }

    it "renders the headers" do
      expect(mail.subject).to eq("You've subscribed to #{category.name}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["notifications@imagegallery.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("You have successfully subscribed to the")
      expect(mail.body.encoded).to match(category.name)
    end
  end

  describe "new_image_notification" do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let(:post) { create(:post, user: user) }
    let(:mail) { NotifierMailer.new_image_notification(user, category, post) }

    it "renders the headers" do
      expect(mail.subject).to eq("New image in #{category.name}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["notifications@imagegallery.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("A new image has been added to the")
      expect(mail.body.encoded).to match(category.name)
      expect(mail.body.encoded).to match(post.title)
    end
  end
end