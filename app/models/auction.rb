class Auction < ActiveRecord::Base
  belongs_to :user
  has_many :rewards, :dependent => :destroy
  accepts_nested_attributes_for :rewards, :allow_destroy => true

  scope :approved, -> { where(:approved => true) }
  scope :not_approved, -> { where("approved IS NULL OR approved = false") }
  scope :custom_order, -> { order(:order) }

  validates :title, :short_description, :description, :about, :target, :start, :end, :volunteer_end_date, :banner, :image, presence: true
  validate :end_date_later_than_start, :volunteer_end_date_later_than_end#, :hours_add_up_to_target, :start_date_later_than_today

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :banner, 
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"

  has_attached_file :image,
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def hours_raised
    reward_ids = self.rewards.map{ |r| r.id }
    bids = Bid.where("reward_id IN (?)", reward_ids)
    bids.inject(0) do |sum, bid|
      increment = bid.hours_entry ? bid.hours_entry.amount : 0
      sum + increment.abs
    end
  end

  def raised_percentage
    "#{(hours_raised.to_f / self.target * 100).round}%"
  end

  def status
    str = "<b>#{num_volunteers}</b> #{'bidder'.pluralize(num_volunteers)} ⋅ "
    str += "<b>#{hours_raised}</b> hrs raised ⋅ "
    str += "<b>#{days_left_to_bid[0]}</b> #{days_left_to_bid[1] + ' left to bid' if days_left_to_bid[0].is_a? Integer}"
    return str.html_safe
  end

  def rewards_ordered_by_lowest
    self.rewards.sort_by do |r|
      r.amount ? r.amount : 0
    end
  end

  def lowest_bid
    if rewards_ordered_by_lowest.first
      rewards_ordered_by_lowest.first.try(:amount)
    else
      nil
    end
  end

  def volunteers
    self.rewards.map {|reward| reward.users }.flatten.uniq
  end

  def num_volunteers
    volunteers.count
  end

  def hours_left_to_bid
    return 0 unless self.end
    (self.end - Time.now).to_i / 60 / 60
  end

  def days_left_to_bid
    hours = hours_left_to_bid
    if hours < 0
      return ["Auction has ended", ""]
    elsif hours == 0
      return ["less than one hour", ""]
    elsif hours < 48
      return [hours, "#{'hour'.pluralize(hours)}"]
    else
      return [hours / 24, "days"]
    end
  end

  def average_bid
    hours_raised == 0 ? 0 : "%g" % (hours_raised.to_f / num_volunteers).round(1)
  end

  def pending_approval
    submitted && !approved
  end

  def started?
    return nil unless self.start
    Time.now >= self.start
  end

  def over?
    return nil unless self.end
    Time.now > self.end
  end

  def general_rewards
    self.rewards.where(:premium => false).order("amount")
  end

  def premium_rewards
    self.rewards.where(:premium => true).order("amount")
  end

  private

  def start_date_later_than_today
    if start.nil? || start < Date.today - 1 # plus one for some leniency and timezone issues
      errors.add(:start, "must be today or later")
    end
  end

  def end_date_later_than_start
    if self.end.nil? || self.end <= start
      errors.add(:end, "must be later than start date")
    end
  end

  def volunteer_end_date_later_than_end
    if volunteer_end_date.nil? || volunteer_end_date <= self.end
      errors.add(:volunteer_end_date, "must be later than auction end date")
    end
  end

  def hours_add_up_to_target
    if has_limited_reward? && target && sum_of_total_possible_reward_hours < target
      errors.add(:target, "target is too high given number of possible reward hours (#{sum_of_total_possible_reward_hours})")
    end
  end

  def has_limited_reward?
    self.rewards.select{ |r| r.limit_bidders != true }.empty?
  end

  def sum_of_total_possible_reward_hours
    self.rewards.inject(0){ |sum, reward| sum + reward.amount * reward.max }
  end
end
