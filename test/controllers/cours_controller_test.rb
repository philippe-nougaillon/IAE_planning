require 'test_helper'

class CoursControllerTest < ActionController::TestCase
  setup do
    @cour = cours(:one)
    @salle = salles(:one)
    @formation = formations(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cour" do
    assert_difference('Cour.count') do
      post :create, cour: { debut: @cour.debut, fin: @cour.fin, formation_id: @formation.id, 
                            intervenant_id: @cour.intervenant_id, nom: @cour.nom, 
                            salle_id: @salle.id, ue: @cour.ue }
    end

    assert_redirected_to cours_path
  end

  test "should show cour" do
    get :show, id: @cour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cour
    assert_response :success
  end

  test "should update cour" do
    patch :update, id: @cour, cour: { 
      debut: @cour.debut, fin: @cour.fin, formation_id: @formation.id, 
      intervenant_id: @cour.intervenant_id, nom: @cour.nom, 
      salle_id: @salle.id, ue: @cour.ue
     }
    assert_redirected_to cours_path
  end

  test "should destroy cour" do
    assert_difference('Cour.count', -1) do
      delete :destroy, id: @cour
    end

    assert_redirected_to cours_path
  end
end
