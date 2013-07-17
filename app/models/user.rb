class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :remember_token
  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :email, case_sensitive: false

  has_secure_password

  has_many :microposts, dependent: :destroy

  before_save { email.downcase! }
  before_save :create_remember_token

  def feed
    microposts
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
