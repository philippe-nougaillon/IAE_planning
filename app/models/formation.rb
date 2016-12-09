class Formation < ActiveRecord::Base

	default_scope { order(:nom, :promo) } 
	validates :nom, presence: true
	validates :nom, uniqueness: true
	
	def nom_promo
		self.promo.blank? ? self.nom : "#{self.nom} -- #{self.promo}" 
	end

end

