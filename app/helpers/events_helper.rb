module EventsHelper

  def get_event_image_or_default(event)
    if event.picture.attached?
      url_for(@event.picture)
    else
      @event.tags.first['photo_url']
    end
  end

  def get_nearby_events_within_radius (radius)
    if(session[:coordinates])
      Event.near([session[:coordinates]['latitude'], session[:coordinates]['longitude']], radius)
    else
      nil
    end
  end
end
