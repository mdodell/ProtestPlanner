class EventsTag < ApplicationRecord
  belongs_to :event
  belongs_to :tag
end
