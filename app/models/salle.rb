class Salle < ActiveRecord::Base

	has_many :cours

	default_scope { order(:nom) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
		
	def nom_places
		self.places.blank? ? self.nom : "#{self.nom} (#{self.places}P)" 
	end
end
