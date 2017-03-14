# Encoding: utf-8

class Cour < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
  belongs_to :salle

  before_validation :update_date_fin

  #validate :la_fin_apres_le_debut
  validates :formation_id, :intervenant_id, :duree, presence: true
  validate :check_chevauchement, if: Proc.new {|cours| cours.salle_id }

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
  
  def self.actions
    ["Changer de salle", "Changer d'état", "Supprimer"]
  end

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

  def progress_bar_pct(planning_date)
    # calcul le % de réalisation du cours
    ((planning_date.to_f - self.debut.to_f) / (self.fin.to_f - self.debut.to_f) * 100).to_i
  end


  private
    def update_date_fin
      fin = eval("self.debut + self.duree.hour")
      self.fin = fin if self.fin != fin
    end

    def la_fin_apres_le_debut
      errors.add(:debut, "du cours ne peut pas être après la fin !") if self.debut > self.fin
    end  

    def check_chevauchement
      # si il y a dejà des cours dans la même salle et à la même date
      cours = Cour.where("salle_id = ? AND (debut BETWEEN ? AND ?) OR (fin BETWEEN ? AND ?)", 
                      self.salle_id, self.debut, self.fin, self.debut, self.fin)

      # si cours en chevauchement n'est pas le cours lui même (modif de cours)
      if cours.any? and !cours.where(id:self.id).any?  

        errors.add(:cours, 'en chevauchement dans la même salle')
      end
    end  

end
