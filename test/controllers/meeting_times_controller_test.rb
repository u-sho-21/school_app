require 'test_helper'

class MeetingTimesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get meeting_times_create_url
    assert_response :success
  end

end
