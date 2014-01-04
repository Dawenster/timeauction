class Reward < ActiveRecord::Base
  belongs_to :auction
  has_and_belongs_to_many :users

  validates :title, :description, :amount, presence: true

  def num_bidders
    self.users.count
  end
end
