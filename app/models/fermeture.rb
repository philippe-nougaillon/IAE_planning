class Fermeture < ActiveRecord::Base

	validates :date, presence: true
	validates :date, uniqueness: true
	
	default_scope { order(:date) } 

end
