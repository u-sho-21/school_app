require 'test_helper'

class DocumentItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get document_items_new_url
    assert_response :success
  end

end
