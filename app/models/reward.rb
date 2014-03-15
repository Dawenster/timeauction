class Reward < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  has_many :users, :through => :bids

  validates :title, :description, :amount, presence: true

  def num_bidders
    self.users.uniq.count
  end

  def maxed_out?
    return false if max.nil?
    num_bidders >= max
  end

  def num_on_waitlist
    num_bidders - max
  end
end
