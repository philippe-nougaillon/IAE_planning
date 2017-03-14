# encoding: UTF-8

class FermeturesController < ApplicationController
  before_action :set_fermeture, only: [:show, :edit, :update, :destroy]

  # GET /fermetures
  # GET /fermetures.json
  def index
    @fermetures = Fermeture.all
  end

  # GET /fermetures/1
  # GET /fermetures/1.json
  def show
  end

  # GET /fermetures/new
  def new
    @fermeture = Fermeture.new
  end

  # GET /fermetures/1/edit
  def edit
  end

  # POST /fermetures
  # POST /fermetures.json
  def create
    @fermeture = Fermeture.new(fermeture_params)

    respond_to do |format|
      if @fermeture.save
        format.html { redirect_to fermetures_url, notice: 'Jour de fermeture ajouté' }
        format.json { render :show, status: :created, location: @fermeture }
      else
        format.html { render :new }
        format.json { render json: @fermeture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fermetures/1
  # PATCH/PUT /fermetures/1.json
  def update
    respond_to do |format|
      if @fermeture.update(fermeture_params)
        format.html { redirect_to fermetures_url, notice: 'Jour de fermeture modifié' }
        format.json { render :show, status: :ok, location: @fermeture }
      else
        format.html { render :edit }
        format.json { render json: @fermeture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fermetures/1
  # DELETE /fermetures/1.json
  def destroy
    @fermeture.destroy
    respond_to do |format|
      format.html { redirect_to fermetures_url, notice: 'Jour de fermeture supprimé' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fermeture
      @fermeture = Fermeture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fermeture_params
      params.require(:fermeture).permit(:date)
    end
end
