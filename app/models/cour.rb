# Encoding: utf-8

class Cour < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
  belongs_to :salle

  validates :formation_id, :intervenant_id, presence: true

  enum etat: [:nouveau, :plannifié, :reporté, :annulé]

  # before_validation(on: :create) do
  #     self.user = RequestStore.store[:current_user]
  # end

  def self.styles
  	 ['label-info','label-success','label-warning','label-danger']
  end

  def style
	  Cour.styles[Cour.etats[self.etat]]
  end
	
  def duree
  	((self.fin - self.debut) / 60) / 60
  end

  # Simple_calendar attributes
  def start_time
    self.debut.to_datetime 
  end
  def end_time
   self.fin.to_datetime
  end

  def nom_ou_ue
    begin
      if self.nom.blank?
        if ue = self.formation.unites.find_by(num:self.ue) 
          "#{self.ue}:#{ue.nom}"
        else
          "UE pas trouvée => #{self.ue}"
        end
      else
        self.nom
      end
    rescue Exception => e 
      "erreur => #{e}"
    end
  end

end
