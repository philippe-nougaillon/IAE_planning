# Encoding: utf-8

class UserMailer < ApplicationMailer

  # Send Welcome Email once Member confirms the account
  def welcome_email(user_id, password)
    @user = User.find(user_id)
    @password = password
    mail(to: @user.email, bcc: 'philippe.nougaillon@gmail.com', subject: "Welcome to IAE-Planning !")
  end

  def cours_changed(cours_id, email)
  	@cours = Cour.find(cours_id)
  	mail(to: email , subject: "[PLANNING] L'état du cours #{@cours.formation.nom}/#{@cours.nom_ou_ue} a été modifié")
  end

end