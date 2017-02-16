class UserMailer < ApplicationMailer

  # Send Welcome Email once Member confirms the account
  def welcome_email(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: "Welcome to IAE-Planning !")
  end
end