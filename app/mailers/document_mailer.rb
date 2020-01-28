class DocumentMailer < ApplicationMailer

  default from: 'rubyonrails.pta@gmail.com'

  def document_mail(user)
    @user_name = user.name + user.name2
    mail(to: user.email, subject: "提出書類のお知らせ")
  end
end
