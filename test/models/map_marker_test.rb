require File.expand_path("../../test_helper", __FILE__)

class MapMarkerTest < ActiveSupport::TestCase
  test 'map marker belongs to user' do
    user = User.new(user_name: 'Jade123', email: 'john@example.com', profile: 'hello', phone: 1234567890,
    password: '1234567890')
    @marker = MapMarker.create(user_id: user.id, event_id: users(:one).events[0],
    latitude: 40,
    longitude: 40,  marker_type: "police")
    assert @marker.user_id == user.id
    @marker.destroy
    user.destroy
  end
end
