class Bid < ActiveRecord::Base
  belongs_to :reward
  belongs_to :user
end