class HoursEntry < ActiveRecord::Base
  validates :amount, :organization, :contact_name, :contact_phone, :contact_email

  belongs_to :user
end


