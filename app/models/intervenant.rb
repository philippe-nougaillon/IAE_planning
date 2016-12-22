# ENCODING: UTF-8

class Intervenant < ActiveRecord::Base

	has_many :cours

	default_scope { order(:nom) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
	
	def nom_prenom
		self.prenom.blank? ? self.nom : "#{self.nom} #{self.prenom}" 
	end

	def total_cours
		self.cours.where(etat:Cour.etats[:plannifié]).count
	end

	def total_heures_de_cours
		sum = 0.0
		self.cours.where(etat:Cour.etats[:plannifié]).each do | c |
			sum += c.duree
		end
		return sum
	end

end
