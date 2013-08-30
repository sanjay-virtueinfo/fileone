require 'test_helper'

class ShareEmailControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
