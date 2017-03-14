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
    @cours = Cour.includes(:formation, :intervenant, :salle).order(:debut)

    unless params[:date].blank?
      @date = params[:date].to_date
      @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @date, @date + 1.day)
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

    unless params[:salle_id].blank?
      @cours = @cours.where(salle_id:params[:salle_id])
    end

    unless params[:ue].blank?
      @cours = @cours.where(ue:params[:ue])
    end

    unless params[:etat].blank?
      @cours = @cours.where(etat:params[:etat])
    end

    params[:view]   ||= 'list'
    params[:filter] ||= 'upcoming'

    if params[:filter] == 'upcoming'
      @cours = @cours.where("cours.debut >= ? ", Date.today)
    end
  end

  def index_slide
    if params[:planning_date]
      @planning_date = DateTime.parse(params[:planning_date] + "+0100")
    else
      @planning_date = DateTime.now 
    end

    # affichier tous les cours du jour à heure H-4 jusqu'à minuit
    limite_debut = @planning_date - 4.hour
    limite_fin = (@planning_date.beginning_of_day) + 1.day  
    @cours = Cour.where("(debut between ? and ?) and fin >= ?", limite_debut, limite_fin, @planning_date).order(:debut)
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
        @cours.save
      end
    elsif action_name == "Supprimer"
      ids.each do |id, state|
        Cour.find(id).destroy
      end
    end 

    flash[:notice] = "Action '#{action_name}' appliquée à #{params[:cours_id].count} cours."
    redirect_to cours_path
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
        format.html { redirect_to @cour, notice: 'Cours modifié avec succès.' }
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
