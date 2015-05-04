class Month < ActiveRecord::Base
  has_and_belongs_to_many :hours_entries
end