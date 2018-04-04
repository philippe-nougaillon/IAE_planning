require 'test_helper'

class ImportLogsControllerTest < ActionController::TestCase
  setup do
    @import_log = import_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:import_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create import_log" do
    assert_difference('ImportLog.count') do
      post :create, import_log: { etat: @import_log.etat, fichier: @import_log.fichier, lignes_importees: @import_log.lignes_importees, message: @import_log.message, nbr_lignes: @import_log.nbr_lignes, type: @import_log.type }
    end

    assert_redirected_to import_log_path(assigns(:import_log))
  end

  test "should show import_log" do
    get :show, id: @import_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @import_log
    assert_response :success
  end

  test "should update import_log" do
    patch :update, id: @import_log, import_log: { etat: @import_log.etat, fichier: @import_log.fichier, lignes_importees: @import_log.lignes_importees, message: @import_log.message, nbr_lignes: @import_log.nbr_lignes, type: @import_log.type }
    assert_redirected_to import_log_path(assigns(:import_log))
  end

  test "should destroy import_log" do
    assert_difference('ImportLog.count', -1) do
      delete :destroy, id: @import_log
    end

    assert_redirected_to import_logs_path
  end
end
