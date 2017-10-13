class Salle < ActiveRecord::Base
	
	audited
	
	has_many :cours

	default_scope { order(:nom) } 
	validates :nom, :places, presence: true
	validates :nom, uniqueness: true
		
	def nom_places
		self.places.blank? ? self.nom : "#{self.nom} (#{self.places}P)" 
	end

end
