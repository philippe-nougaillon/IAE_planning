# ENCODING: UTF-8

class Intervenant < ActiveRecord::Base
	audited

	has_many :cours
	has_many :formations, through: :cours

	validates :nom, :prenom, :email, presence: true
	validates :nom, uniqueness: true
	
  	enum status: [:cev, :permanent]

	default_scope { order(:nom, :prenom) } 

    mount_uploader :photo, AvatarUploader

	def nom_prenom
		self.prenom.blank? ? self.nom.upcase : "#{self.nom.upcase} #{self.prenom}" 
	end

	def total_cours
		self.cours.where(etat:Cour.etats[:planifié]).count
	end

	# def total_heures_de_cours
	# 	sum = 0.0
	# 	self.cours.where(etat:Cour.etats[:planifié]).each do | c |
	# 		sum += c.duree
	# 	end
	# 	return sum
	# end

end
