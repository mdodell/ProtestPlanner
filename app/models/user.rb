class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :user_name, presence: true, length: { maximum: 20 }

  has_many :user_event_relationships
  has_many :events, through: :user_event_relationships


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }


  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
