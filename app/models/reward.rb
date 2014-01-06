class Reward < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  has_many :users, :through => :bids

  validates :title, :description, :amount, presence: true

  def num_bidders
    self.users.count
  end
end
