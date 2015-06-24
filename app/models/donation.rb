class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :nonprofit
  belongs_to :bid
end