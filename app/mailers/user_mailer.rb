# Encoding: utf-8

class UserMailer < ApplicationMailer

  # Send Welcome Email once Member confirms the account
  def welcome_email(user_id, password)
    @user = User.find(user_id)
    @password = password
    mail(to: @user.email, bcc: 'philippe.nougaillon@gmail.com', subject: "Welcome to IAE-Planning !")
  end

  def cours_changed(cours_id, email, etat)
    @cours = Cour.find(cours_id)
    @etat = etat
  	mail(to: email , subject: "[IAE-Paris/PLANNING] L'état du cours #{@cours.nom_ou_ue} - #{@cours.formation.nom}) a été modifié")
  end

end