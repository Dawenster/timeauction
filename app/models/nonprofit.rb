class Nonprofit < ActiveRecord::Base
  has_many :hours_entries
  has_and_belongs_to_many :users

  validates :name, presence: true
end