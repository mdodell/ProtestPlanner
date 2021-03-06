module EventsHelper
  include DatesHelper, SessionsHelper

  def get_event_tag_photo(event)
    event.tags.first['photo_url']
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
      Kaminari.paginate_array(Event.near([session[:coordinates]['latitude'], session[:coordinates]['longitude']], radius).order('date_from ASC')).page(params[:nearby_pages]).per(6)
    end
  end

  def get_upcoming_nearby_events_within_radius (radius)
    if(session[:coordinates])
      Kaminari.paginate_array(Event.near([session[:coordinates]['latitude'], session[:coordinates]['longitude']], radius).where('date_to >= ?', DateTime.now).order('date_from ASC')).page(params[:nearby_pages]).per(6)
    end
  end

  def generate_description(event)
    "#{event.name} is a #{get_tags(event).join(",")} type of protest that will be happening from #{get_full_date_and_time(event.date_from)} to #{get_full_date_and_time(event.date_to)}. The event will be happening at #{event.location}."
  end

  def get_user_attending_future_events
    user_events_query('>', '1', :attending_pages)
  end

  def get_user_attended_past_events
    user_events_query('<', '1', :attended_pages)
  end

  def get_user_organizing_future_events
    user_events_query('>', '0', :organizing_pages)
  end

  def get_user_organized_past_events
    user_events_query('<', '0', :organized_pages)
  end

  private

  def get_tags event
    event.tags.map{|tag| tag.name}
  end

  def user_events_query (sign, role_type, page)
    Kaminari.paginate_array(Event.where("date_from #{sign} ?", DateTime.now).joins(:user_event_relationships).where(user_event_relationships: {user_id: current_user.id, role_type_id: role_type}).sort_by(&:date_from)).page(params[page]).per(6)
  end

  def correct_editor(user, event)
    (user.user_event_relationships.map{|x| x[:event_id]}.include? event.id) && (RoleTypePermission.find_by(id: UserEventRelationship.find_by(user_id: user.id, event_id: event.id).role_type_id).modify_event)
  end
end
