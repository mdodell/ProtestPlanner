class Event < ApplicationRecord
    has_many :user_event_relationships
    has_many :users, through: :user_event_relationships
end
