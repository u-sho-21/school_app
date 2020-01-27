class SendmailMailer < ApplicationMailer
  default from: 'rubyonrails.pta@gmail.com'


  def meeting1_mail(user)
    @username = user.name + user.name2
    mail(to: user.email, subject: "面談日時のお知らせ")
  end

  def meeting2_mail(user)
    @username = user.name + user.name2
    mail(to: user.email, subject: "面談日時確定のお知らせ")
  end

  def document_mail(user)
    @username = user.name + user.name2
    mail(to: user.email, subject: "提出物のお知らせ")
  end
end
