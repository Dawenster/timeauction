class Reward < ActiveRecord::Base
  belongs_to :auction
  has_and_belongs_to_many :users

  validates :title, :description, :amount, presence: true
end
