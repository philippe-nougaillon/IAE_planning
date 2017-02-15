# Encoding: utf-8

class Cour < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
  belongs_to :salle

  validates :formation_id, :intervenant_id, presence: true
  validate :la_fin_apres_le_debut

  validate :check_chevauchement, :if => Proc.new {|cour| cour.salle_id }

  enum etat: [:nouveau, :planifié, :reporté, :annulé, :a_réserver]

  # before_validation(on: :create) do
  #     self.user = RequestStore.store[:current_user]
  # end

  def self.styles
  	['label-info','label-success','label-warning','label-danger','label-primary']
  end

  def style
	  Cour.styles[Cour.etats[self.etat]]
  end
	
  #def duree
  #	self.fin ? ((self.fin - self.debut) / 60) / 60  : 0
  #end

  # Simple_calendar attributes
  def start_time
    self.debut.to_datetime 
  end
  def end_time
    self.fin.to_datetime
  end

  def start_time_short_fr
    I18n.l(self.debut, format: :short) 
  end

  def manque_de_places? 
    (self.formation.nbr_etudiants > self.salle.places)
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

  def photo_json
    self.intervenant.linkedin_photo
  end

  def formation_json
    self.formation.nom
  end

  def salle_json
    self.salle.nom if self.salle
  end

  private
    def la_fin_apres_le_debut
      errors.add(:debut, "du cours ne peut pas être après la fin !") if self.debut > self.fin
    end  

    def check_chevauchement
      if Cour.where("id != ? AND salle_id = ? AND (debut BETWEEN ? AND ?)",self.id, self.salle_id, self.debut, self.fin).any?
        # chevauchement !
        errors.add(:cours, 'en chevauchement dans la même salle')
      end
    end  

end
