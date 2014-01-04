class Auction < ActiveRecord::Base
  belongs_to :user
  has_many :rewards, :dependent => :destroy
  accepts_nested_attributes_for :rewards, :allow_destroy => true

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
    "<b>#{self.hours_raised}</b> hours raised, <b>#{self.raised_percentage}</b> of target".html_safe
  end

  def rewards_ordered_by_lowest
    self.rewards.sort_by{ |r| r.amount }
  end

  def lowest_bid
    rewards_ordered_by_lowest.first.amount
  end

  def num_volunteers
    self.rewards.inject(0) {|sum, reward| sum + reward.users.count }
  end

  def days_left_to_bid
    hours = (self.end - Time.now).to_i / 60 / 60
    if hours < 48
      return [hours, "hours"]
    else
      return [hours / 24, "days"]
    end
  end
end
