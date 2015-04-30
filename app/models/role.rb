class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :nonprofit

  def hours
    HoursEntry.earned.where(:user_id => self.user.id, :nonprofit_id => self.nonprofit.id).sum(:amount)
  end
end