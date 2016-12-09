class Cour < ActiveRecord::Base
  belongs_to :formation
  belongs_to :intervenant
  belongs_to :salle


  validates :formation_id, :intervenant_id, presence: true
	
  def duree
  	((self.fin - self.debut) / 60) / 60
  end

 def start_time
    self.debut 
 end

end
