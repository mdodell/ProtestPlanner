class User < ApplicationRecord
  has_secure_password
  has_many :user_event_relationships
  has_many :events, through: :user_event_relationships
end
