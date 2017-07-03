require 'test_helper'

class FermeturesControllerTest < ActionController::TestCase
  setup do
    @fermeture = fermetures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fermetures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fermeture" do
    assert_difference('Fermeture.count') do
      post :create, fermeture: { date: @fermeture.date }
    end

    assert_redirected_to fermeture_path(assigns(:fermeture))
  end

  test "should show fermeture" do
    get :show, id: @fermeture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fermeture
    assert_response :success
  end

  test "should update fermeture" do
    patch :update, id: @fermeture, fermeture: { date: @fermeture.date }
    assert_redirected_to fermeture_path(assigns(:fermeture))
  end

  test "should destroy fermeture" do
    assert_difference('Fermeture.count', -1) do
      delete :destroy, id: @fermeture
    end

    assert_redirected_to fermetures_path
  end
end
