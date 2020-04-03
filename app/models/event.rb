class Event < ApplicationRecord
    has_many :user_event_relationships
    has_many :map_markers
    has_many :users, through: :user_event_relationships
    has_and_belongs_to_many :tags
    has_one_attached :picture
    validates :name, :location, :date_to, :date_from, presence: true
    validate :valid_date_range_required, :valid_date

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
end
