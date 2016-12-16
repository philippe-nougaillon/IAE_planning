class Formation < ActiveRecord::Base

	default_scope { order(:nom, :promo) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
	
	def nom_promo
		self.promo.blank? ? self.nom : "#{self.nom} - #{self.promo}" 
	end

	def nom_promo_etudiants
		self.promo.blank? ? "#{self.nom} (#{self.nbr_etudiants}E)"  : "#{self.nom} - #{self.promo} (#{self.nbr_etudiants}E)" 
	end

end

