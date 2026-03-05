require "test_helper"

class PremiumControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get premium_index_url
    assert_response :success
  end
end
