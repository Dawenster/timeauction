class HoursEntry < ActiveRecord::Base
  validates :amount, :organization, :contact_name, :contact_phone, :contact_email, presence: true
  validates :contact_email, :format => { :with => /\A[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})\z/, :message => "is not a valid email" }

  belongs_to :user
  belongs_to :reward

  scope :earned, where('amount > 0')
  scope :used, where('amount < 0')
end


