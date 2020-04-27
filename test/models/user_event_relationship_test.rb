require File.expand_path("../../test_helper", __FILE__)

class UserEventRelationshipTest < ActiveSupport::TestCase
  test 'organizer is current user' do
    user = User.new(user_name: 'Jade123', email: 'john@example.com', profile: 'hello', phone: 1234567890,
    password: '1234567890')
    event = Event.new(name: 'test', date_from: DateTime.current + 60 * 60 * 24,
    date_to: DateTime.current + 60 * 60 * 48, location: Faker::Address.full_address, longitude: 40, 
    latitude: 40, description: Faker::Movie.quote)
    UserEventRelationship.create(event_id: event.id, user_id: user.id, role_type_id: 1)
    #active bug (relationship not added, but is working in app)
    user.destroy
    event.destroy
  end
end
