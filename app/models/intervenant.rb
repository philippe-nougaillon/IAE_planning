# ENCODING: UTF-8

class Intervenant < ActiveRecord::Base
	audited

	has_many :cours
	has_many :formations, through: :cours

	validates_uniqueness_of :nom, scope: :email, case_sensitive: false
	validates :nom, :prenom, :email, presence: true
	
  	enum status: [:CEV, :Permanent, :PR, :MCF, :MCF_HDR, :PAST, :PRAG, :VAC, :Admin]

	default_scope { order(:nom, :prenom) } 

    mount_uploader :photo, AvatarUploader

	def self.for_select
		{
		  'Groupe'   => where(doublon:true).map { |i| i.nom },
		  'Individu' => where("intervenants.doublon = ? OR intervenants.doublon is null", false).map { |i| i.nom }
		}
	end
	
	def nom_prenom
		self.prenom.blank? ? self.nom.upcase : "#{self.nom} #{self.prenom}" 
	end

	def total_cours
		self.cours.where(etat:Cour.etats[:confirmé]).count
	end

	# def total_heures_de_cours
	# 	sum = 0.0
	# 	self.cours.where(etat:Cour.etats[:planifié]).each do | c |
	# 		sum += c.duree
	# 	end
	# 	return sum
	# end

end
