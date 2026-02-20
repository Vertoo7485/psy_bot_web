require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get programs_index_url
    assert_response :success
  end

  test "should get show" do
    get programs_show_url
    assert_response :success
  end

  test "should get start" do
    get programs_start_url
    assert_response :success
  end

  test "should get day" do
    get programs_day_url
    assert_response :success
  end
end
