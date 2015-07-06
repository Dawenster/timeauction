class Reward < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  has_many :users, :through => :bids

  validates :title, :description, :amount, presence: true

  def bidders
    self.users.uniq
  end

  def num_bidders
    bidders.count
  end

  def num_premium_bidders
    self.bids.select{ |bid| bid.premium }.count
  end

  def maxed_out?
    return false if max.nil?
    num_premium_bidders >= max
  end

  def spots_available
    return nil if max.nil?
    # max - num_premium_bidders
    max
  end

  def num_on_waitlist
    return 0 if max.nil? || max >= num_bidders
    num_bidders - max
  end

  def successful_bidders
    self.bids.map{ |bid| bid.user if bid.successful? }.uniq
  end

  def num_successful_bidders
    if max.nil? || max >= num_bidders
      num_bidders
    else
      max
    end
  end

  def hours_already_bid_by(user)
    bids = Bid.where(:reward_id => self.id, :user_id => user.id)
    if bids.any?
      hours = bids.inject(0) do |sum, bid|
        sum + bid.hours
      end
      return hours ? hours.abs : 0
    else
      return 0
    end
  end

  def hours_raised
    self.bids.inject(0) do |sum, bid|
      increment = bid.hours_entries.any? ? bid.hours : 0
      sum + increment.abs
    end
  end

  def points_raised
    return self.bids.inject(0) { |sum, bid| sum += bid.points }
  end

  def already_guaranteed_bid_by?(user)
    premium_bids = Bid.where(:reward_id => self.id, :premium => true)
    premium_bids.each do |bid|
      return true if bid.user == user
    end
    return false
  end

  def winning_bids
    self.bids.where(:winning => true)
  end

  def losing_bids
    self.bids.where("winning != ?", true)
  end

  def can_show_hours_raised?
    self.hours_raised > min_hours_to_display
  end

  def display_reward_hours
    if self.can_show_hours_raised?
      "#{self.hours_raised}"
    else
      "< #{min_hours_to_display}"
    end
  end

  def display_karma_points
    if self.can_show_hours_raised?
      "#{self.points_raised}"
    else
      "< #{min_hours_to_display}"
    end
  end

  def hit_target?
    return self.auction.target <= points_raised
  end

  def points_raised
    self.bids.inject(0) { |sum, bid| sum + bid.points }
  end

  private

  def min_hours_to_display
    30 # Make sure not 1 for pluralization reasons
  end
end
