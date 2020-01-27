class Meeting1Mailer < ApplicationMailer

  default from: 'rubyonrails.pta@gmail.com'

  def meeting1_mail(user)
    @user_name = user.name + user.name2
    mail(to: user.email, subject: "面談日時確定のお知らせ")
  end

  def document_mail(user)
    @user_name = user.name + user.name2
    mail(to: user.email, subject: "提出物のお知らせ")
  end

end
