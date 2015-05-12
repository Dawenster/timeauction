class Auction < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  has_many :rewards, :dependent => :destroy
  accepts_nested_attributes_for :rewards, :allow_destroy => true

  scope :approved, -> { where(:approved => true) }
  scope :not_approved, -> { where("approved IS NULL OR approved = false") }
  scope :custom_order, -> { order("display_order ASC") }
  scope :current, -> { where("start_time <= ? AND end_time >= ?", Time.now.utc, Time.now.utc) }
  scope :pending, -> { where("start_time > ?", Time.now.utc) }
  scope :current_or_pending, -> { where("end_time > ?", Time.now.utc) }
  scope :past, -> { where("end_time <= ?", Time.now.utc) }
  scope :not_corporate, -> { where(:program_id => nil) }

  validates :name, :position, :title, :short_description, :description, :about, :start_time, :end_time, :volunteer_end_date, presence: true, :if => :test?
  validates :name, :position, :title, :short_description, :description, :about, :start_time, :end_time, :volunteer_end_date, :banner, :image, presence: true, :unless => :test?
  validate :end_date_later_than_start#, :volunteer_end_date_later_than_end, :hours_add_up_to_target, :start_date_later_than_today

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :banner, 
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png",
                    :s3_protocol => :https

  has_attached_file :image,
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png",
                    :s3_protocol => :https

  def to_param
    "#{id}-#{title.parameterize}-#{name.parameterize}"
  end

  def hours_raised
    if self.start_time < Time.utc(2014,"mar",24,0,0,0)
      legacy_hours_raised
    else
      reward_ids = self.rewards.map{ |r| r.id }
      bids = Bid.where("reward_id IN (?)", reward_ids)
      total = bids.inject(0) do |sum, bid|
        increment = bid.hours_entries.any? ? bid.hours : 0
        sum + increment.abs
      end
      return total
    end
  end

  def legacy_hours_raised
    self.rewards.inject(0) do |sum, reward|
      reward.amount ||= 0
      sum + reward.amount * reward.bids.select{ |bid| bid.successful? }.count
    end
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
    return 0 unless self.end_time
    (self.end_time - Time.now).to_i / 60 / 60
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
    return nil unless self.start_time
    Time.now >= self.start_time
  end

  def over?
    return nil unless self.end_time
    Time.now > self.end_time
  end

  def general_rewards
    self.rewards.where(:premium => false).order("amount")
  end

  def premium_rewards
    self.rewards.where(:premium => true).order("amount")
  end

  def next_current_or_pending(user)
    if user
      auctions = user.current_auctions
      next_auction = nil
      auctions.each_with_index do |auction, i|
        if auction.id == self.id && i != auctions.size
          next_auction = auctions[i + 1]
        elsif auction.id == id && i == auctions.size
          next_auction = auctions[0]
        end
      end
      next_auction ||= auctions.first
    else
      auctions = Auction.approved.not_corporate.current_or_pending
      next_auction = auctions.where("id < ?", id).order("id DESC").first
      next_auction ||= auctions.order("id DESC").first
    end
    return next_auction
  end

  def bids
    self.rewards.map { |reward| reward.bids }.flatten
  end

  def bids_with_comments
    bids.select { |bid| !bid.message.blank? }.sort_by { |b| b.created_at }.reverse
  end

  def won_by_user?(user)
    user.winning_auctions.include?(self)
  end

  def object_pronoun
    case sex
    when "male"
      return "him"
    when "female"
      return "her"
    else
      return "it"
    end
  end

  def name_with_reward(reward)
    "#{self.name}: #{reward.title}#{' (' + self.program.organization.url + ')' if self.program_id}"
  end

  def eligible_months_in_words
    return "#{volunteer_start_date.strftime('%B')} to #{volunteer_end_date.strftime('%B')}"
  end

  private

  def start_date_later_than_today
    if start_time.nil? || start_time < Date.today - 1 # plus one for some leniency and timezone issues
      errors.add(:start_time, "must be today or later")
    end
  end

  def end_date_later_than_start
    if self.end_time.nil? || self.end_time <= start_time
      errors.add(:end_time, "must be later than start date")
    end
  end

  def volunteer_end_date_later_than_end
    if volunteer_end_date.nil? || volunteer_end_date <= self.end_time
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

  def test?
    Rails.env.test?
  end
end
