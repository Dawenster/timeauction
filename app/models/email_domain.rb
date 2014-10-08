class EmailDomain < ActiveRecord::Base
  belongs_to :organization

  validates :domain, uniqueness: true
  validates :domain, presence: true
end