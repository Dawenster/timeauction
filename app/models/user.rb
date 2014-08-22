class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :auctions#, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :rewards, :through => :bids
  has_many :subscribers
  has_many :hours_entries

  before_save :create_username
  after_save :add_to_mailchimp, :if => :updated_name?

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
      user = User.new
      user.skip_confirmation!
      user.assign_attributes(
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
      user.save
    end
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

  def premium_expire_date
    upgrade_date + 1.year
  end

  def formatted_premium_expire_date
    premium_expire_date.strftime("%b %d, %Y")
  end

  def premium_still_valid?
    Time.now <= premium_expire_date
  end

  def premium_and_valid?
    self.premium
    # self.premium && premium_still_valid?
  end

  def volunteer_hours_earned
    self.hours_entries.earned.sum(:amount)
  end

  def volunteer_hours_used
    self.hours_entries.used.sum(:amount).abs
  end

  def hours_left_to_use
    volunteer_hours_earned - volunteer_hours_used
  end

  def earned_reward?(reward)
    hours_entries = HoursEntry.used.where(:user_id => self.id)
    return hours_entries.map{ |entry| entry.bid.reward }.include?(reward)
  end

  def add_to_mailchimp
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => ENV["MAILCHIMP_ENGAGED_NETWORK_LIST_ID"],
      :email => {
        :email => self.email
      },
      :merge_vars => {
        "FNAME" => self.first_name,
        "LNAME" => self.last_name,
        "MMERGE3" => "User"
      },
      :double_optin => false,
      :update_existing => true
    })
  end

  def updated_name?
    first_name_changed? || last_name_changed?
  end
end
