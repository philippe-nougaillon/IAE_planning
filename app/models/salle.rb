class Salle < ActiveRecord::Base
	
	audited
	
	has_many :cours

	default_scope { order(:nom) } 
	validates :nom, :places, presence: true
	validates :nom, uniqueness: true
		
	def self.salles_de_cours
		Salle.where("LENGTH(nom) = 2").where.not(nom:%w{A8 A20 D7 D8 D9})
	end

	def nom_places
		self.places.blank? ? self.nom : "#{self.nom} (#{self.places}P)" 
	end

end
