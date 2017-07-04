# Encoding: utf-8

class UserMailer < ApplicationMailer

  # Send Welcome Email once Member confirms the account
  def welcome_email(user, password)
    @user = user
    @password = password
    mail(to: @user.email, bcc: 'philippe.nougaillon@gmail.com', subject: "Welcome to IAE-Planning !")
  end

  def cours_changed(cours, email)
  	@cours = cours
  	mail(to: email , subject: "[PLANNING] L'état du cours #{cours.formation.nom}/#{cours.nom_ou_ue} a été modifié")
  end

end