# ENCODING: UTF-8

class CoursController < ApplicationController
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
    session[:view] ||= 'list'
    session[:filter] ||= 'upcoming'
    session[:paginate] ||= 'pages'

    if params[:commit] && params[:commit][0..2] == 'RàZ'
      session[:formation] = params[:formation] = nil
      session[:intervenant] = params[:intervenant] = nil
      session[:start_date] = params[:start_date] = Date.today.to_s
      session[:etat] = params[:etat] = nil
      session[:view] = params[:view] = 'list'
      session[:filter] = params[:filter] = 'upcoming'
      session[:paginate] = params[:paginate] = 'pages'
    end

    params[:start_date] ||= session[:start_date]
    params[:formation] ||= session[:formation]
    params[:intervenant] ||= session[:intervenant]
    params[:etat] ||= session[:etat]
    params[:view] ||= session[:view]
    params[:filter] ||= session[:filter]
    params[:paginate] ||= session[:paginate]
    
    @cours = Cour.order(:debut)

    # Si N° de semaine, afficher le premier jour de la semaine choisie, sinon date du jour
    unless params[:semaine].blank?
      if params[:semaine].to_i < Date.today.cweek
        year =  Date.today.year + 1
      else
        year = Date.today.year
      end    
      @date = Date.commercial(year, params[:semaine].to_i, 1)
    else
      unless params[:start_date].blank?
        @date = Date.parse(params[:start_date]) 
      else
        @date = Date.today
      end
    end
    params[:start_date] = @date.to_s
  
    case params[:view]
      when 'list'
        unless params[:filter] == 'all'
          unless params[:semaine].blank?
            @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @date, @date + 7.day)
          else
            @cours = @cours.where("cours.debut >= DATE(?)", @date)
          end
        else
          @date = nil
        end
      when 'calendar_rooms'
        _date = Date.parse(params[:start_date]).beginning_of_week(start_day = :monday)
        @cours = @cours.where(debut: (_date .. _date + 7.day))
        params[:calendar_rooms_starts_at] = _date
      when 'calendar_week'
        _date = Date.parse(params[:start_date]).beginning_of_week(start_day = :monday)
        @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", _date, _date + 7.day)
        params[:calendar_week_starts_at] = _date
      when 'calendar_month'
        _date = Date.parse(params[:start_date]).beginning_of_month
        @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", _date, _date + 1.month)
    end
  
    unless params[:formation_id].blank?
      params[:formation] = Formation.find(params[:formation_id]).nom.rstrip 
    end

    unless params[:formation].blank?
      formation_id = Formation.find_by(nom:params[:formation].rstrip)
      @cours = @cours.where(formation_id:formation_id)
    end

    unless params[:intervenant].blank?
      intervenant = params[:intervenant].strip
      intervenant_id = Intervenant.find_by(nom:intervenant.split(' ').first, prenom:intervenant.split(' ').last.rstrip)
      @cours = @cours.where("intervenant_id = ? OR intervenant_binome_id = ?", intervenant_id, intervenant_id)
    end

    unless params[:intervenant_id].blank?
      intervenant_id = params[:intervenant_id]
      @cours = @cours.where("intervenant_id = ? OR intervenant_binome_id = ?", intervenant_id, intervenant_id)
    end

    unless params[:etat].blank?
      @cours = @cours.where(etat:params[:etat])
    end

    unless params[:salle_id].blank?
      @cours = @cours.where(salle_id:params[:salle_id])      
    end

    unless params[:ue].blank?
      @cours = @cours.where(ue:params[:ue])
    end

    unless params[:ids].blank?
      # affiche les cours d'un ID donné
      @cours = Cour.where(id:params[:ids]).order(:debut)
    end

    @all_cours = @cours

    if (params[:view] == 'list' and params[:paginate] == 'pages' and request.variant.include?(:desktop)) 
      @cours = @cours.paginate(page:params[:page], per_page:20)
    end

    if request.variant.include?(:phone)
      @cours = @cours.paginate(page:params[:page], per_page:30)
    end

    if params[:view] == "calendar_rooms"
      @cours = @cours.where(etat: Cour.etats.values_at(:à_réserver, :planifié, :confirmé, :annulé, :reporté, :réalisé))
    end

    @week_numbers =  ((Date.today.cweek.to_s..'52').to_a << ('1'..(Date.today.cweek - 1).to_s).to_a).flatten
    
    session[:formation] = params[:formation]
    session[:intervenant] = params[:intervenant]
    session[:start_date] = params[:start_date]
    session[:etat] = params[:etat]
    session[:view] = params[:view]
    session[:filter] = params[:filter]
    session[:paginate] = params[:paginate]

    respond_to do |format|
      format.html 
    
      format.csv do
        @csv_string = Cour.generate_csv(@cours, !params[:intervenant])
        filename = "Export_Cours_#{Date.today.to_s}"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
        render "cours/action_do.csv.erb"
      end

      format.ics do
        @calendar = Cour.generate_ical(@cours)
        filename = "Export_iCalendar_#{Date.today.to_s}"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.ics"'
        headers['Content-Type'] = "text/calendar; charset=UTF-8"
        render text:@calendar.to_ical
      end
    end
  end

  def index_slide
    # page courante
    session[:page_slide] ||= 0

    @cours = Cour.where(etat: Cour.etats.values_at(:planifié, :confirmé))
    @now = Time.now.in_time_zone("Paris")
    
    if params[:planning_date]
      # Afficher tous les cours du jours
      @planning_date = Date.parse(params[:planning_date])
      # si date du jour, on ajoute l'heure qu'il est
      @planning_date = @now if @planning_date == Date.today
    else
      # afficher tous les cours du jour à heure H-4 jusqu'à minuit
      @planning_date = @now 
    end
    limite_debut = @planning_date - 4.hour
    limite_fin = (@planning_date.beginning_of_day) + 1.day  
    @cours = @cours.where("(debut between ? and ?) and fin >= ?", limite_debut, limite_fin, @planning_date).order(:debut)

    if @cours.any?
      @cours = @cours.includes(:formation).order("formations.nom")

      if request.variant.include?(:desktop) and !params[:planning_date]
        # effectuer une rotation de x pages de 6 cours 
        per_page = 6
        @max_page_slide = (@cours.count / per_page)
        @max_page_slide += 1 unless @cours.count.%(per_page).zero?

        if session[:page_slide].to_i < @max_page_slide
          session[:page_slide] = session[:page_slide].to_i + 1
        else
          session[:page_slide] = 1
        end
        @cours = @cours.paginate(page:session[:page_slide], per_page:per_page)
      end
    else
      # Affiche un papier peint si pas de cours à afficher
      require 'net/http'
      url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=fr-FR"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)
      @image = json["images"][0]["url"]
    end
  end

  def action
    unless params[:cours_id].blank? or params[:action_name].blank?
      @action_ids = []
      params[:cours_id].keys.each do |id|
        @action_ids << id
      end
    else
      redirect_to cours_path, alert:'Veuillez choisir des cours et une action à appliquer !'
    end
  end

  def action_do
    action_name = params[:action_name]
    ids = params[:cours_id].keys
    @cours = Cour.where(id:ids)

    case action_name 
    when 'Changer de salle'
      salle = !params[:salle_id].blank? ? Salle.find(params[:salle_id]) : nil
      @cours.each do |c|
        c.salle = salle
        flash[:error] = c.errors.messages unless c.save
      end
    when "Changer d'état"
      @cours.each do |c|
        c.etat = params[:etat].to_i
        c.save
        ## envoyer de mail par défaut (after_validation:true) sauf si envoyer email pas coché
        #c.save(validate:params[:email].present?)
      end
    when "Changer d'intervenant"
      @cours.each do |c|
        c.intervenant_id = params[:intervenant_id].to_i
        c.save
      end
    when "Supprimer" 
      if !params[:delete].blank?      
        @cours.each do |c|
          if c.can_be_destroy_by(current_user) # supprimer ce cours que si c'est son créateur qui le demande ou un admin !
            c.destroy
          else 
            flash[:error] = "Vous ne pouvez pas supprimer ce cours (##{c.id}) ! Opération annulée"
            next
          end
        end
      end
    when "Exporter vers Excel"
      @csv_string = Cour.generate_csv(@cours, true)
      request.format = 'csv'
    when "Exporter vers iCalendar"
      @calendar = Cour.generate_ical(@cours)
      request.format = 'ics'
    end 

    respond_to do |format|
      format.html do
        unless flash[:error]
          flash[:notice] = "Action '#{action_name}' appliquée à #{params[:cours_id].count} cours."
        end
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

    unless params[:formation].blank?
      @cour.formation_id = Formation.find_by(nom:params[:formation]).id
    end

    unless params[:intervenant].blank?
      intervenant = params[:intervenant].strip
      intervenant_id = Intervenant.find_by(nom:intervenant.split(' ').first, prenom:intervenant.split(' ').last.rstrip)
      @cour.intervenant_id = intervenant_id
    end
    
    @cour.formation_id = params[:formation_id] if params[:formation_id]
    @cour.intervenant_id = params[:intervenant_id] if params[:intervenant_id] 
    @cour.debut = params[:debut] if params[:debut]
    @cour.ue = params[:ue]
    @cour.salle_id = params[:salle_id]
    @cour.etat = params[:etat].to_i
    @cour.nom = params[:nom]
    if params[:heure]
      @cour.debut = Time.zone.parse("#{params[:debut]} #{params[:heure]}:00").to_s 
    end
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
            redirect_to new_cour_path(debut:@cour.debut, fin:@cour.fin, 
                        formation_id:@cour.formation_id, intervenant_id:@cour.intervenant_id, ue:@cour.ue, salle_id:@cour.salle_id, nom:@cour.nom),
                        notice: 'Cours ajouté avec succès.'
          else
            if params[:from] == 'occupation'
              redirect_to occupation_des_salles_path, notice: "Cours ##{@cour.id} ajouté avec succès."
            else
              redirect_to cours_path, notice: "Cours ##{@cour.id} ajouté avec succès."
            end  
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
        format.html do
          if params[:from] == 'planning_salles'
            redirect_to cours_path(view:"calendar_rooms", start_date:@cour.debut)
          else
            if params[:from] == 'occupation'
              redirect_to occupation_des_salles_path, notice: "Cours ##{@cour.id} ajouté avec succès."
            else
              redirect_to cours_url, notice: 'Cours modifié avec succès.'
            end
          end
        end
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
      params.require(:cour).permit(:debut, :fin, :formation_id, :intervenant_id, 
                                    :salle_id, :ue, :nom, :etat, :duree,
                                    :intervenant_binome_id, :hors_service_statutaire)
    end
end
