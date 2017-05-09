# ENCODING: UTF-8

class FormationsController < ApplicationController
  before_action :set_formation, only: [:show, :edit, :update, :destroy]

  # check if logged and admin  
  before_filter except: :show do 
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end

  # GET /formations
  # GET /formations.json
  def index
    @formations = Formation.all

    unless params[:nom].blank?
      @formations = @formations.where("nom like ?", "%#{params[:nom]}%")
    end

    unless params[:diplome].blank?
      @formations = @formations.where(diplome:params[:diplome])
    end

    unless params[:apprentissage].blank?
      @formations = @formations.where(apprentissage:true)
    end

    unless params[:promo].blank?
      @formations = @formations.where(promo:params[:promo])
    end
    @formations = @formations.order(:nom, :promo)
    @formations = @formations.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /formations/1
  # GET /formations/1.json
  def show
  end

  # GET /formations/new
  def new
    @formation = Formation.new
    2.times { @formation.unites.build}
  end

  # GET /formations/1/edit
  def edit
    2.times { @formation.unites.build}
  end

  # POST /formations
  # POST /formations.json
  def create
    @formation = Formation.new(formation_params)

    respond_to do |format|
      if @formation.save
        format.html { redirect_to @formation, notice: 'Formation ajoutée' }
        format.json { render :show, status: :created, location: @formation }
      else
        format.html { render :new }
        format.json { render json: @formation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /formations/1
  # PATCH/PUT /formations/1.json
  def update
    respond_to do |format|
      if @formation.update(formation_params)
        format.html { redirect_to @formation, notice: 'Formation modifiée' }
        format.json { render :show, status: :ok, location: @formation }
      else
        format.html { render :edit }
        format.json { render json: @formation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /formations/1
  # DELETE /formations/1.json
  def destroy
    @formation.destroy
    respond_to do |format|
      format.html { redirect_to formations_url, notice: 'Formation supprimée.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formation
      @formation = Formation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def formation_params
      params.require(:formation).permit(:nom, :promo, :diplome, :domaine, :apprentissage, :memo, :nbr_etudiants, :nbr_heures,                                   :abrg, :user_id, :color, unites_attributes: [:id, :num, :nom, :_destroy])
    end
end
