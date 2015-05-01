class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :nonprofit

  def hours
    HoursEntry.earned.where(:user_id => self.user.id, :nonprofit_id => self.nonprofit.id).sum(:amount)
  end

  def can_show_hours?
    hours > 0
  end
end