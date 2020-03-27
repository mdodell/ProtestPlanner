class Event < ApplicationRecord
    has_many :user_event_relationships
    has_many :users, through: :user_event_relationships
    has_and_belongs_to_many :tags
    has_one_attached :picture
    validates :name, :location, :date_to, :date_from, presence: true
    validate :valid_date_range_required

    geocoded_by :location



    def valid_date_range_required
        if (date_to.present? && date_from.present?) && (date_to < date_from)
            errors.add(:date_to, "Must be later than the from date!")
        end
    end

    def valid_date
        if date_from.present? && (date_from < DateTime.current)
            errors.add(:date_from, "Starting date cannot be in the past!")
        end
    end

    #backend method to find the closest 5 (or less if there are not 5 close events)
    #events to user (in params)
    def findNearbyEvents(current_user_id)
        nearby = {} #this dict stores the event and its distance from users location
        Event.all do | id, location_lat, location_long |
            distance = Geocoder::Calculations.distance_between(
                [User.find(current_user_id).location_lat, User.find(current_user_id).location_long],
                [location_lat, location_long])
            # if distance < 10
            nearby[:id] = distance
            # end
        end
        nearby.sort_by {|_key, value| value}
        if nearby.length > 5
            return a[0..5]
        else 
            return nearby
        end
    end
end
