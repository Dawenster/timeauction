class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable#, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :auctions, :dependent => :destroy
  has_and_belongs_to_many :rewards

  before_save :create_username

  def display_name
    if self.first_name && self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.username
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
        first_name: auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
        username: auth.extra.raw_info.username,
        timezone: auth.extra.raw_info.timezone,
        gender: auth.extra.raw_info.gender,
        facebook_image: auth.info.image,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end
    user.skip_confirmation!
    user
  end

  def create_username
    self.username = self.to_slug
  end

  def to_slug
    self.username.parameterize
  end
end
