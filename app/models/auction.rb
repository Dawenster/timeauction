class Auction < ActiveRecord::Base
  belongs_to :user
  has_many :tiers
  accepts_nested_attributes_for :tiers

  validates :title, :description, :target, :start, :end, presence: true
end
