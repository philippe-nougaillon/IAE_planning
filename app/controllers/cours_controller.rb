# ENCODING: UTF-8

class CoursController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  before_action :set_cour, only: [:show, :edit, :update, :destroy]
  
  layout :define_layout

  def define_layout
    if params[:action] == 'index_slide'
      'slide'
    else
      'application'
    end
  end

  # GET /cours
  # GET /cours.json
  def index
    params[:view] ||= 'list'
    params[:filter] ||= 'upcoming'
    params[:paginate] ||= 'pages'

    @cours = Cour.includes(:formation, :intervenant, :salle).order(:debut)

    if params[:view] == "calendar_rooms" and params[:start_date].blank? 
      @date = Date.today.beginning_of_week(start_day = :monday)
      params[:start_date] = @date.to_s
    end

    unless params[:start_date].blank? 
      @date = Date.parse(params[:start_date])
      params[:semaine] = @date.cweek if params[:semaine] != @date.cweek 
      @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @date, @date + 7.day)
    end

    # unless params[:semaine].blank?      
    #   @date = Date.commercial(Date.today.year, params[:semaine].to_i, 1)
    #   params[:start_date] = @date.to_s if params[:start_date] != @date.to_s 
    #   @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @date, @date + 7.day)
    # end

    if params[:start_date].blank? and !params[:semaine].blank?
      params[:semaine] = nil
      flash[:alert] = "Veuillez choisir une date"
    end

    if current_user.formation 
      params[:formation_id] = current_user.formation_id
    end

    unless params[:formation_id].blank?
      @cours = @cours.where(formation_id:params[:formation_id])
    end

    unless params[:intervenant_id].blank?
      @cours = @cours.where(intervenant_id:params[:intervenant_id])
    end

    # unless params[:ue].blank?
    #   @cours = @cours.where(ue:params[:ue])
    # end

    unless params[:etat].blank?
      @cours = @cours.where(etat:params[:etat])
    end

    unless params[:salle_id].blank?
      @cours = @cours.where(salle_id:params[:salle_id])      
    end

    if params[:filter] == 'upcoming'
      @cours = @cours.where("cours.debut >= ? ", Date.today)
    end


    @all_cours = @cours

    if params[:view] == 'list' and params[:paginate] == 'pages'
      @cours = @cours.paginate(page:params[:page], per_page:20)
    end

    if params[:view] == "calendar_rooms"
      @cours = @cours.planifié
    end

  end

  def index_slide
    if params[:planning_date]
      @planning_date = DateTime.parse(params[:planning_date] + "+0100")
    else
      @planning_date = DateTime.now 
    end

    # afficher tous les cours du jour à heure H-4 jusqu'à minuit
    limite_debut = @planning_date - 4.hour
    limite_fin = (@planning_date.beginning_of_day) + 1.day  
    @cours = Cour.where("(debut between ? and ?) and fin >= ?", limite_debut, limite_fin, @planning_date).order(:debut)

    unless params[:formation_id].blank?
      @cours = @cours.where(formation_id:params[:formation_id])
    end

    unless params[:intervenant_id].blank?
      @cours = @cours.where(intervenant_id:params[:intervenant_id])
    end
  end

  def action
    if params[:cours_id]
      @action_ids = []
      params[:cours_id].each do |id, state|
        @action_ids << id
      end
    end
  end

  def action_do
    action_name = params[:action_name]
    ids = params[:cours_id]

    if action_name == 'Changer de salle'
      ids.each do |id, state|
        @cours = Cour.find(id)
        unless params[:salle_id].blank?
          @cours.salle = Salle.find(params[:salle_id])
        else
          @cours.salle = nil
        end
        @cours.save
      end

    elsif action_name == "Changer d'état"
      ids.each do |id, state|
        @cours = Cour.find(id)
        @cours.etat = params[:etat].to_i
        
        # envoyer de mail par défaut (after_validation:true) sauf si envoyer email pas choché
        @cours.save(validate:params[:email].present?)
      end

    elsif action_name == "Supprimer" and !params[:delete].blank?      
      ids.each do |id, state|
        cours = Cour.find(id)
        # supprimer que si c'est le créateur qui le demande !
        if current_user.id == cours.audits.first.user_id
          cours.destroy
        end
      end

    elsif action_name == "Exporter vers Excel"
      require 'csv'

      @csv_string = CSV.generate(col_sep:';', encoding:'iso-8859-1') do | csv |
          csv << ['id','date debut', 'heure debut', 'date fin','heure fin', 'formation_id','formation','intervenant_id','intervenant','nom du cours', 'etat','duree', 'Forfait_HETD', 'Taux_TD', 'Code_Analytique', 'cours cree le', 'cours modifie le']
      
          ids.each do |id, state|
            c = Cour.find(id)
            csv << [c.id, c.debut.to_date.to_s, c.debut.to_s(:time), c.fin.to_date.to_s, c.fin.to_s(:time), 
              c.formation_id, c.formation.nom_promo, c.intervenant_id, c.intervenant.nom_prenom, c.nom, c.etat, 
              number_with_delimiter(c.duree, separator: ","), c.formation.Forfait_HETD, c.formation.Taux_TD, 
              c.formation.Code_Analytique, c.created_at, c.updated_at]
          end
      end
      request.format = 'csv'

    elsif action_name == "Exporter vers iCalendar"
      require 'icalendar'

      @calendar = Icalendar::Calendar.new
      ids.each do |id, state|
        cours = Cour.find(id)
      
        event = Icalendar::Event.new
        event.dtstart = cours.debut.strftime("%Y%m%dT%H%M%S")
        event.dtend = cours.fin.strftime("%Y%m%dT%H%M%S")
        event.summary = cours.formation.nom
        event.description = cours.nom
        event.location = "BioPark #{cours.salle.nom if cours.salle}"
        @calendar.add_event(event)
      end  
      @calendar.publish

      request.format = 'ics'
    end 

    respond_to do |format|
      format.html do
        flash[:notice] = "Action '#{action_name}' appliquée à #{params[:cours_id].count} cours."
        redirect_to cours_path
      end

      format.csv do
        filename = "Export_Cours_#{Date.today.to_s}"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
        render "cours/action_do.csv.erb"
      end

      format.ics do
        filename = "Export_iCalendar_#{Date.today.to_s}"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.ics"'
        headers['Content-Type'] = "text/calendar; charset=UTF-8"
        render text:@calendar.to_ical
      end
    end
  end

  # GET /cours/1
  # GET /cours/1.json
  def show
  end

  # GET /cours/new
  def new
    @cour = Cour.new
    @cour.formation_id = params[:formation_id]
    @cour.debut = params[:fin] 
    @cour.intervenant_id = params[:intervenant_id]
    @cour.ue = params[:ue]
  end

  # GET /cours/1/edit
  def edit
  end

  # POST /cours
  # POST /cours.json
  def create
    @cour = Cour.new(cour_params)

    respond_to do |format|
      if @cour.save
        format.html do
          if params[:create_and_add]  
            redirect_to new_cour_path(debut:@cour.debut, fin:@cour.fin, formation_id:@cour.formation_id, intervenant_id:@cour.intervenant_id, ue:@cour.ue), notice: 'Cours ajouté avec succès.'
          else
            redirect_to @cour, notice: 'Cours ajouté avec succès.'
          end 
        end
        format.json { render :show, status: :created, location: @cour }
      else
        format.html { render :new }
        format.json { render json: @cour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cours/1
  # PATCH/PUT /cours/1.json
  def update
    respond_to do |format|
      if @cour.update(cour_params)
        format.html { redirect_to cours_url, notice: 'Cours modifié avec succès.' }
        format.json { render :show, status: :ok, location: @cour }
      else
        format.html { render :edit }
        format.json { render json: @cour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cours/1
  # DELETE /cours/1.json
  def destroy
    @cour.destroy
    respond_to do |format|
      format.html { redirect_to cours_url, notice: 'Cours supprimé.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cour
      @cour = Cour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cour_params
      params.require(:cour).permit(:debut, :fin, :formation_id, :intervenant_id, :salle_id, :ue, :nom, :etat, :duree)
    end
end
