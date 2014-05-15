class Bid < ActiveRecord::Base
  has_one :hours_entry, :dependent => :destroy
  belongs_to :reward
  belongs_to :user

  def successful?
    reward = self.reward
    nth_bid = reward.bids.sort_by{|b|b.created_at}.index(self) + 1
    nth_bid <= reward.max
  end

  def waitlist?
    !self.successful?
  end

  def hours
    if self.hours_entry
      self.hours_entry.amount.abs
    else
      self.reward.amount
    end
  end

  def chance_of_winning
    (hours.to_f / self.reward.hours_raised * 100).round
  end
end