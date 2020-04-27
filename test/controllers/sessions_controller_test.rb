require File.expand_path("../../test_helper", __FILE__)

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    url = sessions_new_url
    assert_not_nil url
  end

end
