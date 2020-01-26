class SendmailMailer < ApplicationMailer
  default from: 'rubyonrails.pta@gmail.com'


  def meeting1_mail(user)
    @username = user.name + user.name2
    mail(to: user.email, subject: "面談日時のお知らせ")
  end
end
