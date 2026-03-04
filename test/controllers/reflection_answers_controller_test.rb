require "test_helper"

class ReflectionAnswersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reflection_answers_create_url
    assert_response :success
  end
end
