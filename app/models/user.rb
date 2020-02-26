class User < ApplicationRecord
    has_many :user_event_relationships
    has_many :events, through: :user_event_relationships

    #backend method to find the events that specified user is an organizer
    #of
    # def eventsUserOrganizes(current_user_id)
    #     organizer_events = []
    #     UserEventRelationship.all do | user_id, event_id, role_type_id |
    #         if user_id == current_user_id and role_type_id == 1
    #             organizer_events.push(event_id)
    #         end
    #     end
    #     return organizer_events
    # end


end


