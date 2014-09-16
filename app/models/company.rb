class Company < ActiveRecord::Base
  has_many :users
  has_many :email_domains, :dependent => :destroy
  has_many :programs, :dependent => :destroy
  accepts_nested_attributes_for :email_domains, :allow_destroy => true

  validates :url, uniqueness: true
  validates :url, :name, presence: true

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :logo, 
                    :styles => { :thumb => "300x300#", :display => "540x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"

  has_attached_file :background_image,
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"


end