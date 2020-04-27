require File.expand_path("../../test_helper", __FILE__)
require_relative '../helpers/sign_in_helper'

class MarkersControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  fixtures :users

  setup do
    sign_in_as(users(:one), 'secret')
  end

  test 'can add marker' do
    @marker = MapMarker.create(user_id: users(:one).id,
    event_id: users(:one).events[0],
    latitude: 40,
    longitude: 40,
    marker_type: "police"
    )
    refute_nil @marker
    assert @marker.marker_type == "police"
    @marker.destroy
  end
end
