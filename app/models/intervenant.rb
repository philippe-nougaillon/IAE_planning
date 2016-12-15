class Intervenant < ActiveRecord::Base

	has_many :cours

	default_scope { order(:nom) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
	
	def nom_prenom
		self.prenom.blank? ? self.nom : "#{self.nom} #{self.prenom}" 
	end

end
