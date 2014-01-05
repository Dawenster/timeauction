class Auction < ActiveRecord::Base
  belongs_to :user
  has_many :rewards, :dependent => :destroy
  accepts_nested_attributes_for :rewards, :allow_destroy => true

  validates :title, :short_description, :description, :about, :target, :start, :end, :banner, :image, presence: true

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :banner, 
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => "timeauction"

  has_attached_file :image,
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => "timeauction"

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def hours_raised
    self.rewards.inject(0) {|sum, reward| sum + reward.amount * reward.users.count }
  end

  def raised_percentage
    "#{(hours_raised.to_f / self.target * 100).round}%"
  end

  def status
    str = "<b>#{num_volunteers}</b> bidder#{'s' unless num_volunteers == 1} ⋅ "
    str += "<b>#{hours_raised}</b> hrs raised ⋅ "
    str += "<b>#{days_left_to_bid[0]}</b> #{days_left_to_bid[1]} left to bid"
    return str.html_safe
  end

  def rewards_ordered_by_lowest
    self.rewards.sort_by{ |r| r.amount }
  end

  def lowest_bid
    rewards_ordered_by_lowest.first.amount
  end

  def num_volunteers
    self.rewards.map {|reward| reward.users }.flatten.uniq.count
  end

  def hours_left_to_bid
    (self.end - Time.now).to_i / 60 / 60
  end

  def days_left_to_bid
    hours = hours_left_to_bid
    if hours < 48
      return [hours, "hours"]
    else
      return [hours / 24, "days"]
    end
  end

  def average_bid
    hours_raised == 0 ? 0 : "%g" % (hours_raised.to_f / num_volunteers)
  end
end
