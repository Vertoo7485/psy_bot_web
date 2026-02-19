require "test_helper"

class TestResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get test_results_show_url
    assert_response :success
  end
end
