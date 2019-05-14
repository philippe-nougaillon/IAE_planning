# ENCODING: UTF-8

class IntervenantsController < ApplicationController
  before_action :set_intervenant, only: [:show, :edit, :update, :destroy]

  # check if logged and admin  
  # before_filter do 
  #   redirect_to new_user_session_path unless current_user && current_user.admin?
  # end

  # GET /intervenants
  # GET /intervenants.json
  def index
    @intervenants = Intervenant.order(:nom)

    unless params[:nom].blank?
      @intervenants = @intervenants.where("nom like ? or prenom like ?", "%#{params[:nom]}%", "%#{params[:nom]}%" )
    end

    unless params[:doublon].blank?
      @intervenants = @intervenants.where(doublon:true)
    end

    unless params[:status].blank?
      @intervenants = @intervenants.where("status = ?", params[:status])
    end
    @intervenants = @intervenants.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /intervenants/1
  # GET /intervenants/1.json
  def show
    @formations = @intervenant.formations.uniq
  end

  # GET /intervenants/new
  def new
    @intervenant = Intervenant.new
    2.times { @intervenant.responsabilites.build }
  end

  # GET /intervenants/1/edit
  def edit
    1.times { @intervenant.responsabilites.build }
  end

  # POST /intervenants
  # POST /intervenants.json
  def create
    @intervenant = Intervenant.new(intervenant_params)

    respond_to do |format|
      if @intervenant.save
        format.html { redirect_to @intervenant, notice: 'Intervenant ajouté.' }
        format.json { render :show, status: :created, location: @intervenant }
      else
        format.html { render :new }
        format.json { render json: @intervenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /intervenants/1
  # PATCH/PUT /intervenants/1.json
  def update
    respond_to do |format|
      if @intervenant.update(intervenant_params)
        format.html { redirect_to @intervenant, notice: 'Intervenant modifié.' }
        format.json { render :show, status: :ok, location: @intervenant }
      else
        format.html { render :edit }
        format.json { render json: @intervenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intervenants/1
  # DELETE /intervenants/1.json
  def destroy
    @intervenant.destroy
    respond_to do |format|
      format.html { redirect_to intervenants_url, notice: 'Intervenant supprimé.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intervenant
      @intervenant = Intervenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def intervenant_params
      params.require(:intervenant).permit(:nom, :prenom, :email, :linkedin_url, :titre1, :titre2, :spécialité,
       :téléphone_fixe, :téléphone_mobile, :bureau, :photo, :status, :remise_dossier_srh, :adresse, :cp, :ville, :doublon,
       :nbr_heures_statutaire, :date_naissance, :memo, :notifier,
       responsabilites_attributes: [:id, :debut, :fin, :titre, :formation_id, :heures, :commentaires, :_destroy])
    end
end
