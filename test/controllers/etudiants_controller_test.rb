require 'test_helper'

class EtudiantsControllerTest < ActionController::TestCase
  setup do
    @etudiant = etudiants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:etudiants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etudiant" do
    assert_difference('Etudiant.count') do
      post :create, etudiant: { email: @etudiant.email, formation_id: @etudiant.formation_id, mobile: @etudiant.mobile, nom: @etudiant.nom, prénom: @etudiant.prénom }
    end

    assert_redirected_to etudiant_path(assigns(:etudiant))
  end

  test "should show etudiant" do
    get :show, id: @etudiant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @etudiant
    assert_response :success
  end

  test "should update etudiant" do
    patch :update, id: @etudiant, etudiant: { email: @etudiant.email, formation_id: @etudiant.formation_id, mobile: @etudiant.mobile, nom: @etudiant.nom, prénom: @etudiant.prénom }
    assert_redirected_to etudiant_path(assigns(:etudiant))
  end

  test "should destroy etudiant" do
    assert_difference('Etudiant.count', -1) do
      delete :destroy, id: @etudiant
    end

    assert_redirected_to etudiants_path
  end
end
