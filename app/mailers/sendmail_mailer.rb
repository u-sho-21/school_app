class SendmailMailer < ApplicationMailer
  default from: 'rubyonrails.pta@gmail.com'


  def meeting1_mail(user)
    @username = username.name + username.name2
    mail(to: user.email, subject: "面談日時のお知らせ")
  end
end
