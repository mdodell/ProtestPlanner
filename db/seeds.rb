# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.delete_all
Event.delete_all
UserEventRelationship.delete_all
MapMarker.delete_all
RoleTypePermission.delete_all


10.times do
    User.create(
                  user_name: Faker::Name.name,
                  email: Faker::Internet.email,
                  profile: Faker::Hacker.say_something_smart,
                  phone: Faker::Number.number(digits:10),
                  password: Faker::Number.number(digits:10).to_s
    )
end

5.times do
  Event.create(
      name: Faker::Movie.quote,
      tag_id: Faker::Number.within(range: 1..10),
      date_from: Faker::Date.backward(days: 14),
      date_to: Faker::Date.forward(days: 1),
      location: Faker::Address.full_address,
      location_long: Faker::Address.longitude,
      location_lat: Faker::Address.latitude,
      description: Faker::Movie.quote
  )
end

5.times do
  UserEventRelationship.create(event_id: Event.all.sample.id, user_id: User.all.sample.id, role_type_id: 1)
end

5.times do
  UserEventRelationship.create(event_id: Event.all.sample.id, user_id: User.all.sample.id, role_type_id: 0)
end



#5.times do
#    event_name = (Faker::Hacker.ingverb + " " + Faker::Hacker.noun + "s").capitalize
#    Event.create(name: event_name, event_date: Faker::Date.between(from: 1.year.ago, to: 1.day.ago), event_time: '12:00pm')
#  end
  
  #(1..10).each do
  #  p = Person.create(name: Faker::Name.name,
  #    dob: Faker::Date.between(from: 30.years.ago, to: 10.years.ago),
  #    gender: ['f', 'm'].sample, zipcode: Faker::Address.zip)
  #end
  
  #3.times do
  #  r = Registration.create(person_id: Person.all.sample.id, event_id: Event.all.sample.id)
  #end
