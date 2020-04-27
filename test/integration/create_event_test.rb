require File.expand_path("../../test_helper", __FILE__)
require_relative '../helpers/sign_in_helper'

class CreateEventTest < ActionDispatch::IntegrationTest
  include SignInHelper
  fixtures :users

  test "can create an event" do
    sign_in_as(users(:one), 'secret')
    get "/events/new"
    assert_response :success
    assert_equal "/events/new", path
    post '/events', params: { event: { name: "Event Title", description: "Description", location: "Search Results
1600 Pennsylvania Ave NW, Washington, DC 20500", date_from: DateTime.now + 10, date_to: DateTime.now + 15, latitude: -35.000000, longitude: 100.000000}}
    assert_response :found
    follow_redirect!
    assert_equal event_path, path
  end
end
