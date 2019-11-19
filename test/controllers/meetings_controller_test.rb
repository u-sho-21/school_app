require 'test_helper'

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get meetings_new_url
    assert_response :success
  end

end
