# encoding: utf-8

require 'test_helper'

class IntervenantsControllerTest < ActionController::TestCase
  setup do
    @intervenant = intervenants(:one)
    @intervenant2 = intervenants(:two)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intervenants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intervenant" do
    assert_difference('Intervenant.count') do
      post :create, intervenant:  @intervenant2
    end

    assert_redirected_to intervenant_path(assigns(:intervenant))
  end

  test "should show intervenant" do
    get :show, id: @intervenant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @intervenant
    assert_response :success
  end

  test "should update intervenant" do
    patch :update, id: @intervenant, intervenant: { nom: @intervenant.nom }
    assert_redirected_to intervenant_path(assigns(:intervenant))
  end

  test "should destroy intervenant" do
    assert_difference('Intervenant.count', -1) do
      delete :destroy, id: @intervenant
    end

    assert_redirected_to intervenants_path
  end
end
