class EmailDomain < ActiveRecord::Base
  belongs_to :company

  validates :domain, uniqueness: true
  validates :domain, presence: true
end