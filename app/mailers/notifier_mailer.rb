class NotifierMailer < ApplicationMailer

  def simple_message(recipient)
    attachments["attachment.pdf"] = File.read("path/to/file.pdf")
    mail(
      to: "pospelvv@gmail.com",
      subject: "New account information"
    )
  end
end
