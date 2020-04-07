module EventsHelper
  include DatesHelper, UsersHelper

  def get_event_image_or_default(event)
    if event.picture.attached?
      url_for(@event.picture)
    else
      @event.tags.first['photo_url']
    end
  end

  def display_register_or_unregister_button (event)
    if UserEventRelationship.where(event_id: event.id, user_id: current_user.id).exists?
      link_to 'Unregister', unregister_path(event.id), method: :delete, class: 'btn-danger btn registration-button'
    else
      link_to 'Register', register_path(event.id), method: :post, class: 'btn-primary text-white btn registration-button'
    end
  end

  def get_nearby_events_within_radius (radius)
    if(session[:coordinates])
      Event.near([session[:coordinates]['latitude'], session[:coordinates]['longitude']], radius)
    else
      nil
    end
  end

  def generate_description event
    "#{event.name} is a #{get_tags(event).join(",")} type of protest that will be happening from #{get_full_date_and_time(event.date_from)} to #{get_full_date_and_time(event.date_to)}. The event will be happening at #{event.location}."
  end

  private

  def get_tags event
    event.tags.map{|tag| tag.name}
  end

  def correct_editor(user, event)
    (user.user_event_relationships.map{|x| x[:event_id]}.include? event.id) && (RoleTypePermission.find_by(id: UserEventRelationship.find_by(user_id: user.id, event_id: event.id).role_type_id).modify_event)
  end
end
