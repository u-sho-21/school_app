require 'test_helper'

class DocumentSelectsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get document_selects_new_url
    assert_response :success
  end

end
