class Reward < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  has_many :users, :through => :bids

  validates :title, :description, :amount, presence: true

  def num_bidders
    self.users.uniq.count
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
    max - num_premium_bidders
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
        if !bid.hours_entry.nil? && bid.hours_entry.amount < 0
          sum + bid.hours_entry.amount
        else
          sum + 0
        end
      end
      return hours ? hours.abs : 0
    else
      return 0
    end
  end

  def hours_raised
    bids = Bid.where(:reward_id => self.id)
    bids.inject(0) do |sum, bid|
      increment = bid.hours_entry ? bid.hours_entry.amount : 0
      sum + increment.abs
    end
  end

  def already_guaranteed_bid_by?(user)
    premium_bids = Bid.where(:reward_id => self.id, :premium => true)
    premium_bids.each do |bid|
      return true if bid.user == user
    end
    return false
  end
end
