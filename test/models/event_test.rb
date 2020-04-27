require File.expand_path("../../test_helper", __FILE__)

class EventTest < ActiveSupport::TestCase
  test 'valid event' do
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
    event.destroy
  end

  test 'event cannot start in past' do
    event = Event.new(
      name: 'eventtest',
      date_from: DateTime.current - 60 * 60 * 24,
      date_to: DateTime.current + 60 * 60 * 48,
      location: Faker::Address.full_address,
      longitude: Faker::Address.longitude,
      latitude: Faker::Address.latitude,
      description: 'a great event'
  )
    refute event.valid?, 'event that starts in past is valid'
    assert_not_nil event.errors[:date_from], 'no validation event in past'
    event.destroy
  end

  test 'event must have name' do
    event = Event.new(
      date_from: DateTime.current - 60 * 60 * 24,
      date_to: DateTime.current + 60 * 60 * 48,
      location: Faker::Address.full_address,
      longitude: Faker::Address.longitude,
      latitude: Faker::Address.latitude,
      description: 'a great event'
  )
    refute event.valid?, 'event that does not have name is valid'
    assert_not_nil event.errors[:name], 'no validation error for event without name'
    event.destroy
  end


end