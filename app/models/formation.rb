class Formation < ActiveRecord::Base
	
	has_many :cours, dependent: :destroy
	
	has_many :unites
	accepts_nested_attributes_for :unites, allow_destroy: true, reject_if: lambda {|attributes| attributes['num'].blank?}

	validates :nom, presence: true
	validates :nom, uniqueness: {scope: :promo}
	
	default_scope { order(:nom, :promo) } 
	
	def nom_promo
		self.promo.blank? ? self.nom : "#{self.nom} - #{self.promo}" 
	end

	def nom_promo_etudiants
		self.promo.blank? ? "#{self.nom} (#{self.nbr_etudiants}E)"  : "#{self.nom} - #{self.promo} (#{self.nbr_etudiants}E)" 
	end

end

