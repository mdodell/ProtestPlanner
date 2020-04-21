class Event < ApplicationRecord
    has_many :user_event_relationships
    has_many :map_markers
    has_many :users, through: :user_event_relationships
    has_many :events_tags
    has_many :tags, through: :events_tags
    has_one_attached :picture
    validates :name, :location, :date_to, :date_from, presence: true
    validate :valid_date_range_required, :valid_date, :image_type

    geocoded_by :location

    def image_type
        if picture.attached? && !picture.content_type.in?(%('image/jpeg image/png'))
            errors.add(:picture, "needs to be a jpeg or png!")
        end
    end

    def valid_date_range_required
        if (date_to.present? && date_from.present?) && (date_to < date_from)
            errors.add(:date_to, "Must be later than the from date!")
        end
    end

    def valid_date
        if date_from.present? && (date_from < DateTime.now)
            errors.add(:date_from, "Starting date cannot be in the past!")
        end
    end

    scope :with_name, proc { |name|
        if name.present?
           where("lower(events.name) like ?", "%#{name.downcase}%")
        end
    }

    scope :with_tag, proc { |tag|
        if tag.present?
            joins(:events_tags).where(events_tags: {tag_id: tag})
        end
    }

    scope :with_location, proc { |location, latitude, longitude|
        if location.present?
            near([latitude, longitude], 5)
        end
    }

    scope :with_date, proc { |date|
        if date.present?
            if date == 'Today'
                where(date_from: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
            elsif date == 'Tomorrow'

                where(date_from: DateTime.tomorrow.beginning_of_day..DateTime.tomorrow.end_of_day)
            elsif date == 'This Week'
                where(date_from: DateTime.now.beginning_of_week..DateTime.now.end_of_week)
            elsif date == 'Next Week'
                where(date_from: DateTime.now.beginning_of_week.advance(:days => +7)..DateTime.now.end_of_week.advance(:days => +7))
            elsif date == 'This Month'
                where(date_from: DateTime.now.beginning_of_month..DateTime.now.end_of_month)
            elsif date == 'Next Month'
                where(date_from: DateTime.now.beginning_of_month.advance(:months => +1)..DateTime.now.end_of_month.advance(:months => +1))
            else
                where('date_from >= ?', DateTime.now)
            end
        end
    }

    def self.filter(params)
        with_name(params[:keyword]).with_tag(params[:tags]).with_date(params[:date]).with_location(params[:location], params[:latitude], params[:longitude])
    end
end
