require 'test_helper'

class FormationsControllerTest < ActionController::TestCase
  setup do
    @formation = formations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formation" do
    assert_difference('Formation.count') do
      post :create, formation: { apprentissage: @formation.apprentissage, diplome: @formation.diplome, domaine: @formation.domaine, nom: @formation.nom, promo: @formation.promo }
    end

    assert_redirected_to formation_path(assigns(:formation))
  end

  test "should show formation" do
    get :show, id: @formation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @formation
    assert_response :success
  end

  test "should update formation" do
    patch :update, id: @formation, formation: { apprentissage: @formation.apprentissage, diplome: @formation.diplome, domaine: @formation.domaine, nom: @formation.nom, promo: @formation.promo }
    assert_redirected_to formation_path(assigns(:formation))
  end

  test "should destroy formation" do
    assert_difference('Formation.count', -1) do
      delete :destroy, id: @formation
    end

    assert_redirected_to formations_path
  end
end
