class Nonprofit < ActiveRecord::Base
  has_many :hours_entries
  has_many :users, :through => :roles

  validates :name, presence: true
end