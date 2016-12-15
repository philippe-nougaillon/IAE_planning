# ENCODING: UTF-8

class CoursController < ApplicationController
  before_action :set_cour, only: [:show, :edit, :update, :destroy]

  # GET /cours
  # GET /cours.json
  def index
    @cours = Cour.order(:debut)

    unless params[:date_debut].blank? and params[:date_fin].blank?
        @date_debut = params[:date_debut].to_date
        @date_fin = params[:date_fin].to_date
        @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @date_debut, @date_fin)
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

    params[:view] ||= "list"

  end

  # GET /cours/1
  # GET /cours/1.json
  def show
  end

  # GET /cours/new
  def new
    @cour = Cour.new
    @cour.debut = params[:debut]
    @cour.fin = params[:fin]  
    @cour.formation_id = params[:formation_id]
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
      params.require(:cour).permit(:debut, :fin, :formation_id, :intervenant_id, :salle_id, :ue, :nom, :etat)
    end
end
