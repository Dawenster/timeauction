class Bid < ActiveRecord::Base
  has_one :hours_entry, :dependent => :destroy
  belongs_to :reward
  belongs_to :user
end