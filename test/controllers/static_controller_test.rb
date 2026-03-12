require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get install" do
    get static_install_url
    assert_response :success
  end
end
