class Tag < ApplicationRecord
  #has_and_belongs_to_many :events
  has_many :events_tags
  has_many :events, through: :events_tags
end
