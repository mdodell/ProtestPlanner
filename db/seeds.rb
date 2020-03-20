require 'json'
require 'active_record'
require 'activerecord-import'

User.delete_all
Event.delete_all
UserEventRelationship.delete_all
MapMarker.delete_all
RoleTypePermission.delete_all
Tag.delete_all

tags = []
tag_columns = [:name, :photo_url]
tags_file = File.read(Rails.root.join('db', 'json', 'tags.json'))
tags_hash = JSON.parse(tags_file)
tags_hash.each do |tag|
  tags << {
      name: tag['name'],
      photo_url: tag['photo_url']
  }
end

Tag.import tag_columns, tags, validate: false

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
      tag_id: Tag.all.sample.id,
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
