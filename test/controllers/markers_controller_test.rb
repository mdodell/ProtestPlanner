require 'test_helper'

class MarkersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get markers_create_url
    assert_response :success
  end

  test "should get show" do
    get markers_show_url
    assert_response :success
  end

end
