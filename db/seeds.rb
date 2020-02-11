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


100.times do
    User.create(
                first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: Faker::Internet.email,
                  profile: Faker::Hacker.say_something_smart,
                  phone: Faker::Number.number(digits:10),
                  password: Faker::Number.number(digits:10).to_s
                  )
  end

