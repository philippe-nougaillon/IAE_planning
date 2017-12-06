require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  
  setup do
    sign_in users(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
