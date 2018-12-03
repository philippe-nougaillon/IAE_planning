# Encoding: utf-8

class Cour < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
  belongs_to :intervenant_binome, class_name: :Intervenant, foreign_key: :intervenant_binome_id 
  belongs_to :salle

  validates :debut, :formation_id, :intervenant_id, :duree, presence: true
  validate :check_chevauchement_intervenant
  validate :check_chevauchement, if: Proc.new {|cours| cours.salle_id }
  validate :jour_fermeture
  validate :reservation_dates_must_make_sense

  before_validation :update_date_fin
  before_validation :sunday_morning_praise_the_dawning

  before_save :change_etat_si_salle
  before_save :annuler_salle_si_cours_est_annulé

  after_validation :call_notifier

  enum etat: [:planifié, :à_réserver, :confirmé, :reporté, :annulé, :réalisé]
  
  def self.styles
    ['label-info','label-warning','label-success','label-danger','label-danger','label-default']
  end

  def style
    Cour.styles[Cour.etats[self.etat]]
  end
  
  def self.actions
    ["Changer d'intervenant", "Exporter vers Excel", "Exporter vers iCalendar", "Exporter en PDF"]
  end

  def self.actions_admin
    ["Changer de salle", "Changer d'état", "Changer de date", "Changer d'intervenant", "Exporter vers Excel", "Exporter vers iCalendar", "Exporter en PDF", "Supprimer"]
  end

  def self.etendue_horaire
    [8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]
  end

  def self.ue_styles
    ['#D4D8D1','#A8A8A1','#AA9A66','#B74934','#577492','#67655D','#332C2F','#432C2F','#732C2F','#932C2F']
  end

  def self.cumul_heures(start_date)
    nombre_heures_cours_jour = nombre_heures_cours_soir = 0
    Cour.where(etat: Cour.etats.values_at(:confirmé, :réalisé)).where("Date(debut) = ? ", start_date).each do |c|
      # si le cours commence avant 18h
      if c.debut.hour < 18
        nombre_heures_cours_jour += c.duree.to_f
      else
        nombre_heures_cours_soir += c.duree.to_f
      end
    end
    return [nombre_heures_cours_jour, nombre_heures_cours_soir]   
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
    (self.salle.places > 0 && self.formation.nbr_etudiants > self.salle.places)
  end

  def nom_ou_ue
    begin
      if self.nom.blank?        
        unless self.ue.blank?
          if ue = self.formation.unites.find_by(num:self.ue.upcase)
            ue.num_nom
          end        
        end  
      else
        "#{self.nom} #{self.elearning ? "(E-learning)" : ''}"
      end
    rescue Exception => e 
      "erreur => #{e}"
    end
  end

  def url?
    # Correct URL ?
    self.nom =~ /https?:\/\/[\S]+/
  end

  # render json methods:
  def photo_json
    if self.intervenant.photo 
      self.intervenant.photo.url
    end 
  end

  def formation_json
    self.formation.nom_promo
  end

  def intervenant_json
    self.intervenant.nom_prenom
  end

  def salle_json
    self.salle.nom if self.salle
  end

  def duree_json
    (self.fin - self.debut).to_f / 60
  end

  def matiere_json
    self.nom_ou_ue
  end

  # def elearning?
  #   if self.salle
  #     self.salle.nom[0..3] == 'ZOOM'
  #   else
  #     false
  #   end
  # end

  def Taux_TD
    # Taux particuliers
    if ["Jeu d'entreprise", "Pratique de l'entreprise", "Simulation de gestion"].include?(self.nom)
      1
    else
      # Taux général de la formation
      Formation.unscoped.find(self.formation_id).Taux_TD
    end
  end

  def HETD
    self.duree * self.Taux_TD.to_f
  end

  def CMTD?
    self.Taux_TD == 1.5 ? 'CM' : 'TD'
  end  

  def progress_bar_pct(planning_date = nil)
    # calcul le % de réalisation du cours
    @now = DateTime.now.in_time_zone("Paris") + 1.hours
    ((@now.to_f - self.debut.to_f) / (self.fin.to_f - self.debut.to_f) * 100).to_i
  end

  def range
    # retourne l'étendue d'un cours sous la forme d'une suite d'heures. Ex: 8 9 pour un cours de 8 à 10h
    range = []

    (self.debut.hour .. self.fin.hour).each do | hour |
       range << hour
    end 

    if range.size == 1  
      return range # afficher le créneau même si le cours ne dure qu'une demi-heure
    else
      return range[0..-2] # enlève le dernier créneau horaire pour ne pas afficher la dernière heure comme occupée
    end
  end

  def can_be_destroy_by(user)
    # on peut supprimer ce cours si c'est son créateur qui le demande ou le gestionnaire de formation ou un admin !
    (user.id == self.audits.first.user_id) or (self.formation.user == user) or (user.admin?) 
  end  

  def self.generate_csv(cours, exporter_binome, voir_champs_privés = false)
    require 'csv'
    
    CSV.generate(col_sep:';', quote_char:'"', encoding:'UTF-8') do | csv |
        csv << ['id','Date début','Heure début','Date fin','Heure fin','Formation_id','Formation',
                'Code_Analytique','Intervenant_id','Intervenant','UE','Intitulé','Binôme?','Etat',
                'Salle','Durée','HSS ? (Hors Service Statutaire)','E-learning', 'Taux_TD','HETD',
                'Commentaires','Cours créé le','Par','Cours modifié le']
    
        cours.each do |c|
          hetd = c.duree * (c.formation.Taux_TD || 0)
          fields_to_export = [c.id, c.debut.to_date.to_s, c.debut.to_s(:time), c.fin.to_date.to_s, c.fin.to_s(:time), 
            c.formation_id, c.formation.nom_promo, c.formation.Code_Analytique, 
            c.intervenant_id, c.intervenant.nom_prenom, c.ue, c.nom, 
            (c.intervenant_binome ? "#{c.intervenant.nom}/#{c.intervenant_binome.nom}" : ''), 
            c.etat, (c.salle ? c.salle.nom : ""), 
            c.duree.to_s.gsub(/\./, ','),
            (c.hors_service_statutaire ? "OUI" : ''),
            (c.elearning ? "OUI" : ''), 
            (voir_champs_privés ? c.formation.Taux_TD : ''),
            (voir_champs_privés ? hetd.to_s.gsub(/\./, ',') : ''),
            (voir_champs_privés ? c.commentaires : ''),
            c.created_at,
            c.audits.first.user.try(:email),
            c.updated_at
          ]
          csv << fields_to_export
          
          # créer une ligne d'export supplémentaire pour le cours en binome
          if exporter_binome and c.intervenant_binome
            fields_to_export[8] = c.intervenant_binome_id
            fields_to_export[9] = c.intervenant_binome.nom_prenom 
            csv << fields_to_export
          end  
        end
    end
  end

  def self.generate_ical(cours)
    require 'icalendar'
    
    calendar = Icalendar::Calendar.new
    cours.each do | c |
      event = Icalendar::Event.new
      event.dtstart = c.debut.strftime("%Y%m%dT%H%M%S")
      event.dtend = c.fin.strftime("%Y%m%dT%H%M%S")
      event.summary = c.formation.nom
      event.description = c.nom
      event.location = "BioPark #{c.salle.nom if c.salle}"
      calendar.add_event(event)
    end  
     return calendar
  end

  def self.generate_etats_services_csv(cours)
    require 'csv'

    @cumul_hetd = 0.0
    CSV.generate(col_sep:';', quote_char:'"', encoding:'UTF-8') do | csv |
        csv << ['Le','Formation','Code','Intitulé','Commentaires','Durée','HSS?','E-learning?',
                'CM/TD?', 'Taux_TD','HETD','Cumul']
    
        cours.each do |c|
          hetd = c.duree * (c.formation.Taux_TD || 0)
          unless c.hors_service_statutaire
            @cumul_hetd += c.HETD
          end

          fields_to_export = [
            I18n.l(c.debut, format: :perso),
            c.formation.nom_promo, c.formation.Code_Analytique, 
            c.nom_ou_ue, 
            c.commentaires,
            c.duree.to_s.gsub(/\./, ','),
            (c.hors_service_statutaire ? "OUI" : ''),
            (c.elearning ? "OUI" : ''), 
            c.CMTD?, 
            c.formation.Taux_TD.to_s.gsub(/\./, ','),
            hetd.to_s.gsub(/\./, ','),
            @cumul_hetd.to_s.gsub(/\./, ',')
          ]
          csv << fields_to_export
        end
    end
  end

  private
    def update_date_fin
      if self.debut and self.duree
        fin = eval("self.debut + self.duree.hour")
        self.fin = fin if self.fin != fin
      end
    end

    def sunday_morning_praise_the_dawning # :)
      if self.debut.wday == 0
        errors.add(:cours, "ne peut pas avoir lieu un dimanche !")
      end
    end

    def call_notifier
      # envoyer un mail si le cours a changé d'état vers annulé ou reporté
      if self.changes.include?('etat') and (self.etat == 'annulé' or self.etat == 'reporté') 
        # logger.debug "[DEBUG] etat modifié: #{self.etat_was} => #{self.etat}"

        # envoyer notification au chargé de formation
        if self.formation.user
          UserMailer.cours_changed(self.id, self.formation.user.email, self.etat).deliver_now
        end

        # envoyer à tous les étudiants 
        self.formation.etudiants.each do | etudiant |
          UserMailer.cours_changed(self.id, etudiant.email, self.etat).deliver_now
        end
      end

      # envoyer un mail à Pascal pour faire la réservation de cours
      #if self.changes.include?('etat') and (self.etat == 'à_réserver') 
      #  UserMailer.cours_changed(self.id, "wachnick.iae@univ-paris1.fr").deliver_later
      #end 
    end  

    def reservation_dates_must_make_sense
      if fin <= debut 
        errors.add(:fin, "du cours ne peut pas être avant son commencement !")
      end
    end

    def check_chevauchement

      # Pas de test si les doublons sont autorisés
      return if self.salle.places == 0
            
      # s'il y a dejà des cours dans la même salle et à la même date
      cours = Cour.where("salle_id = ? AND (((debut BETWEEN ? AND ?) OR (fin BETWEEN ? AND ?)) OR (debut < ? AND fin > ?))", 
                          self.salle_id, self.debut, self.fin, self.debut, self.fin, self.fin, self.debut)

      # si cours en chevauchement n'est pas le cours lui même (modif de cours)
      cours = cours.where.not(id:self.id).where.not(fin:self.debut).where.not(debut:self.fin)

      if cours.any?
        cours_links = []
        cours.each do |c| 
          cours_links << "<a href='/cours/#{c.id}'>#{c.id}</a>"
        end
        errors.add(:cours, "en chevauchement (période, salle) avec le cours #{cours_links.join(',')}")
      end
    end  

    def check_chevauchement_intervenant

      # Pas de test si pas d'intervenant
      return unless self.intervenant
      # Pas de test si les doublons sont autorisés
      return if self.intervenant.doublon 

      # s'il y a dejà des cours dans la même salle et à la même date
      cours = Cour.where("intervenant_id = ? AND ((debut BETWEEN ? AND ?) OR (fin BETWEEN ? AND ?))", 
                          self.intervenant_id, self.debut, self.fin, self.debut, self.fin)

      # si cours en chevauchement n'est pas le cours lui même (modif de cours)
      cours = cours.where.not(id:self.id).where.not(fin:self.debut).where.not(debut:self.fin)

      if cours.any?
        errors.add(:cours, "en chevauchement (période, intervenant) avec le(s) cours ##{cours.pluck(:id).join(',')}")
      end
    end  

    def jour_fermeture
      if Fermeture.find_by(date:self.debut.to_date)
        errors.add(:cours, 'sur une date de fermeture !')
      end
    end

    def change_etat_si_salle
      if (self.etat == 'planifié' or self.etat == 'à_réserver' or self.etat == 'confirmé') and (self.salle_id_was == nil and self.salle_id != nil)
          self.etat = 'confirmé'
          errors.add(:cours, 'état changé !')
      end   
    end

    def annuler_salle_si_cours_est_annulé
      if (self.etat == 'annulé') and (self.salle_id != nil)
          self.salle_id = nil
          errors.add(:cours, 'état changé & salle libérée ')
      end   
    end
end
