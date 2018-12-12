# ENCODING: UTF-8

class Intervenant < ActiveRecord::Base

	audited

	has_many :cours
	has_many :formations, through: :cours
	has_many :responsabilites
	accepts_nested_attributes_for :responsabilites, allow_destroy:true, reject_if: lambda {|attributes| attributes['titre'].blank?}

	has_many :vacations

	validates_uniqueness_of :nom, scope: :email, case_sensitive: false
	validates :nom, :email, :prenom, :status, presence: true
	
  	enum status: [:CEV, :Permanent, :PR, :MCF, :MCF_HDR, :PAST, :PRAG, :Admin]

	default_scope { order(:nom, :prenom) } 

    #mount_uploader :photo, AvatarUploader

	def self.for_select
		{
		  'Groupes (Doublons autorisés)' => where(doublon:true).map { |i| "#{i.nom} #{i.prenom}" },
		  'Individus' => where("intervenants.doublon = ? OR intervenants.doublon is null", false).map { |i| "#{i.nom} #{i.prenom}"  }
		}
	end
	
	def nom_prenom
		self.prenom.blank? ? self.nom.upcase : "#{self.nom} #{self.prenom}" 
	end

	def total_cours
		self.cours.where(etat:Cour.etats[:confirmé]).count
	end

end
