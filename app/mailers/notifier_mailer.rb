class NotifierMailer < ApplicationMailer
  default from: 'notifications@imagegallery.com'

  def simple_message(recipient)
    attachments["attachment.pdf"] = File.read("path/to/file.pdf")
    mail(
      to: "pospelvv@gmail.com",
      subject: "New account information"
    )
  end
  
  def category_subscription(user, category)
    @user = user
    @category = category
    mail(
      to: user.email,
      subject: "You've subscribed to #{category.name}"
    )
  end
  
  def new_image_notification(user, category, post)
    @user = user
    @category = category
    @post = post
    mail(
      to: user.email,
      subject: "New image in #{category.name}"
    )
  end
end
