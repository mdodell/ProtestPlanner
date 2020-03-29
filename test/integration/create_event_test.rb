require 'test_helper'

class CreateEventTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "can login and create an event" do
    get "/login"
    assert_response :success

    post "/login", params: {user_name: users(:one).user_name, password: 'secret'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path

    get "/events/new"
    assert_response :success
    post '/events', params: { event: { name: "Event Title", description: "Description", location: "Search Results
1600 Pennsylvania Ave NW, Washington, DC 20500", date_from: DateTime.now + 10, date_to: DateTime.now + 15, latitude: -35.000000, longitude: 100.000000}}
    assert_response :redirect
    follow_redirect!
  end
end
