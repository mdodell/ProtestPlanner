require File.expand_path("../../test_helper", __FILE__)

class EventsTagTest < ActiveSupport::TestCase
  test 'event has default tag' do
    event = Event.new(
      name: 'eventtest',
      date_from: DateTime.current + 60 * 60 * 24,
      date_to: DateTime.current + 60 * 60 * 48,
      location: Faker::Address.full_address,
      longitude: Faker::Address.longitude,
      latitude: Faker::Address.latitude,
      description: 'a great event'
  )
    assert event.valid?
    assert_not_nil event.tags, 'no default event tag'
    event.destroy
  end

  test 'can have multiple tags' do
    event = Event.new(
      name: 'eventtest',
      date_from: DateTime.current + 60 * 60 * 24,
      date_to: DateTime.current + 60 * 60 * 48,
      location: Faker::Address.full_address,
      longitude: Faker::Address.longitude,
      latitude: Faker::Address.latitude,
      description: 'a great event'
  )
    event.tags.destroy
    event.tags << Tag.all[0]
    event.tags << Tag.all[1]
    assert event.tags.include?(Tag.all[0])
    assert event.tags.include?(Tag.all[1])
    event.destroy
  end
end
