class Bid < ActiveRecord::Base
  has_many :hours_entries, :dependent => :destroy
  belongs_to :reward
  belongs_to :user

  accepts_nested_attributes_for :hours_entries, :allow_destroy => true

  after_save :mark_winner_on_mailchimp, :if => :winning_changed?

  def successful?
    reward = self.reward
    nth_bid = reward.bids.sort_by{|b|b.created_at}.index(self) + 1
    nth_bid <= reward.max
  end

  def waitlist?
    !self.successful?
  end

  def hours
    if self.used_entries.any?
      self.used_entries.inject(0) do |sum, entry|
        sum + entry.amount.abs
      end
    else
      self.reward.amount
    end
  end

  def earned_entries
    self.hours_entries.select{|entry| entry.earned? }
  end

  def used_entries
    self.hours_entries.select{|entry| entry.used? }
  end

  def chance_of_winning
    (hours.to_f / self.reward.hours_raised * 100).round
  end

  def verified?
    if self.earned_entries.any?
      return !self.earned_entries.map{ |entry| entry.verified }.include?(false)
    else
      hours_entry = HoursEntry.where(:bid_id => self.id)
      if hours_entry.any?
        return HoursEntry.find(hours_entry.first.id - 1).verified
      else
        return hours_entry.any?
      end
    end
  end

  def update_mailchimp(activity)
    user = self.user
    activity = "Winner" if user.won_before?

    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => ENV["MAILCHIMP_ENGAGED_NETWORK_LIST_ID"],
      :email => {
        :email => user.email
      },
      :merge_vars => {
        "MMERGE4" => activity
      },
      :double_optin => false,
      :update_existing => true
    })
  end

  def mark_winner_on_mailchimp
    status = winning ? "Winner" : "Bidder"
    self.update_mailchimp(status)
  end

  def send_confirmation_email
    BidMailer.admin_confirmation_email(self).deliver
    self.update_attributes(:confirmation_sent_at => Time.now)
  end

  def send_waitlist_email
    BidMailer.admin_waitlist_email(self).deliver
    self.update_attributes(:waitlist_sent_at => Time.now)
  end
end