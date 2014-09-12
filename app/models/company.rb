class Company < ActiveRecord::Base
  has_many :email_domains
  has_many :users

  validates :url, uniqueness: true
  validates :url, presence: true
  validates :name, presence: true
end