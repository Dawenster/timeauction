class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :auctions, :dependent => :destroy
  has_many :bids
  has_many :rewards, :through => :bids, :before_remove => :destroy_bids
  has_many :subscribers

  before_save :create_username

  def destroy_bids(reward)
    Bid.where(campaign_id: id, device_id: device.id).destroy_all
  end

  def display_name
    if !self.first_name.blank? && !self.last_name.blank?
      "#{self.first_name} #{self.last_name}"
    else
      self.username
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if signed_in_resource && signed_in_resource.uid.nil?
      signed_in_resource.update_options(signed_in_resource, auth)
      return signed_in_resource
    end

    user_with_same_email_as_fb = User.find_by_email(auth.info.email)
    if user_with_same_email_as_fb && user_with_same_email_as_fb.uid.nil?
      user_with_same_email_as_fb.update_options(user_with_same_email_as_fb, auth)
      return user_with_same_email_as_fb
    end

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

  def update_options(user, auth)
    options = {
      timezone: auth.extra.raw_info.timezone,
      gender: auth.extra.raw_info.gender,
      facebook_image: auth.info.image,
      provider: auth.provider,
      uid: auth.uid
    }
    options[:username] = auth.extra.raw_info.username unless user.username
    options[:first_name] = auth.extra.raw_info.first_name unless user.first_name
    options[:last_name] = auth.extra.raw_info.last_name unless user.last_name
    self.update_attributes(options)
  end

  def create_username
    self.username = self.to_slug
  end

  def to_slug
    self.username.parameterize
  end
end
