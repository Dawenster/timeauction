class Auction < ActiveRecord::Base
  belongs_to :user
  has_many :tiers, :dependent => :destroy
  accepts_nested_attributes_for :tiers, :allow_destroy => true

  validates :title, :description, :target, :start, :end, :banner, :image, presence: true

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :banner, 
                    :styles => { :thumb => "300x225#", :display => "600x450#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => "timeauction"

  has_attached_file :image,
                    :styles => { :thumb => "300x225#", :display => "600x450#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => "timeauction"
end
