class Meeting2Mailer < ApplicationMailer

  default from: 'rubyonrails.pta@gmail.com'

  def meeting2_mail(user)
    @user_name = user.name + user.name2
    mail(to: user.email, subject: "面談のお知らせ")
  end

end
