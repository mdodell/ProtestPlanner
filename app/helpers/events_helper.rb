module EventsHelper

  def get_event_image_or_default(event)
    if event.picture.attached?
      url_for(@event.picture)
    else
      @event.tags.first['photo_url']
    end
  end
end
