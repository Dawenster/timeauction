class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :first_name, :last_name, presence: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
        first_name: auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
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
end
