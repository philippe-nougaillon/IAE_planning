class Salle < ActiveRecord::Base

	default_scope { order(:nom) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
		
	def nom_places
		self.places.blank? ? self.nom : "#{self.nom} (#{self.places}P)" 
	end
end
