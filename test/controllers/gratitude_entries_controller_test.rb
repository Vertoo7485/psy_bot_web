require "test_helper"

class GratitudeEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get gratitude_entries_create_url
    assert_response :success
  end

  test "should get index" do
    get gratitude_entries_index_url
    assert_response :success
  end
end
