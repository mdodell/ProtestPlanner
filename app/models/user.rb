class User < ApplicationRecord
  has_one_attached :avatar
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest

  has_many :user_event_relationships
  has_many :events, through: :user_event_relationships


  validates :user_name, presence: true, length: { maximum: 26 }, uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 },
            format: { with: VALID_EMAIL_REGEX }


  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

end
