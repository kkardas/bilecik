require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get login," do
    get session_login,_url
    assert_response :success
  end

  test "should get home," do
    get session_home,_url
    assert_response :success
  end

  test "should get profile," do
    get session_profile,_url
    assert_response :success
  end

  test "should get setting" do
    get session_setting_url
    assert_response :success
  end

end
