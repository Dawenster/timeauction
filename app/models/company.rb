class Company < ActiveRecord::Base
  has_many :email_domains
  has_many :users
end