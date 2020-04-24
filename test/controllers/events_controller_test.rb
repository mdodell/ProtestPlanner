require 'test_helper'
require_relative '../helpers/sign_in_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  fixtures :users

  setup do
    @event = events(:one)
    sign_in_as(users(:one), 'secret')
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should show event" do
    get event_url(events(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: {  } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
