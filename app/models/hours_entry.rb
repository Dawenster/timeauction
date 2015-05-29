class HoursEntry < ActiveRecord::Base
  include ApplicationHelper
  
  validates :organization, :amount, :contact_name, :contact_phone, :contact_email, :dates, :description, presence: true, :if => :user_entered?
  validates :contact_email, :format => { :with => /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i, :message => "is not a valid email", :multiline => true }, :if => :user_entered?
  validates_numericality_of :amount, greater_than: 0, :if => :user_entered?

  before_save :link_to_nonprofit, :if => :can_link_to_nonprofit?

  belongs_to :user
  belongs_to :bid
  belongs_to :nonprofit

  scope :earned, -> { where('amount > ? AND verified = ?', 0, true) }
  scope :pending, -> { where('amount > ? AND verified != ?', 0, true) }
  scope :logged, -> { where('amount > 0') }
  scope :used, -> { where('amount < 0') }

  def earned?
    amount > 0
  end

  def used?
    !earned?
  end

  def amount_in_words
    "#{amount} volunteer #{'hour'.pluralize(amount)}"
  end

  def send_verification_email(hk)
    if hk
      HoursEntryMailer.verification_hk(self).deliver
    else
      HoursEntryMailer.verification(self).deliver
    end
    self.update_verification_sent_at
  end

  def self.total_verified_hours
    return HoursEntry.earned.inject(0) { |sum, entry| sum + entry.amount }
  end

  def self.total_hours_pending_verification
    return HoursEntry.pending.inject(0) { |sum, entry| sum + entry.amount }
  end

  def user_already_has?(nonprofit)
    self.user.nonprofits.where(:id => nonprofit.id).any?
  end

  def display_dates
    if month && year
      return "#{Date::MONTHNAMES[self.month]}, #{self.year}"
    else
      return dates
    end
  end

  def similar_unverified_entries
    return HoursEntry.where(:contact_email => self.contact_email, :description => self.description, :verified => false)
  end

  def update_verification_sent_at
    similar_unverified_entries.each do |entry|
      entry.update_attributes(:verification_sent_at => Time.now)
    end
  end

  def send_verified_emails
    similar_unverified_entries.each do |entry|
      entry.update_attributes(:verified => true)
    end
    HoursEntryMailer.verified(self).deliver
  end

  private

  def user_entered?
    user_entered
  end


  def newly_verified?
    verified && verified_changed? && amount > 0
  end

  def link_to_nonprofit
    nonprofit = Nonprofit.find_by_slug_or_create(self.organization)
    self.user.nonprofits << nonprofit unless user_already_has?(nonprofit)
    self.nonprofit_id = nonprofit.id
  end

  def can_link_to_nonprofit?
    if !organization.blank?
      amount_bid = amount || self.bid.reward.amount
      return amount_bid > 0
    end
  end
end


