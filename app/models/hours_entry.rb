class HoursEntry < ActiveRecord::Base
  include ApplicationHelper
  
  validates :organization, :amount, :contact_name, :contact_phone, :contact_email, :dates, :description, presence: true, :if => :user_entered?
  validates :contact_email, :format => { :with => /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i, :message => "is not a valid email", :multiline => true }, :if => :user_entered?
  validates_numericality_of :amount, greater_than: 0, :if => :user_entered?

  before_save :send_verified_email
  before_save :link_to_nonprofit, :if => :can_link_to_nonprofit?
  # before_save :link_to_months

  has_and_belongs_to_many :months
  belongs_to :user
  belongs_to :bid
  belongs_to :nonprofit

  scope :earned, -> { where('amount > ? AND verified = ?', 0, true) }
  scope :pending, -> { where('amount > ? AND verified != ?', 0, true) }
  scope :logged, -> { where('amount > 0') }
  scope :used, -> { where('amount < 0') }

  def amount # support previous way of putting hours on the hours_entry table
    if read_attribute(:amount)
      read_attribute(:amount)
    else
      self.months.sum(:hours)
    end
  end

  def earned?
    amount > 0
  end

  def used?
    !earned?
  end

  def amount_in_words
    "#{amount} volunteer #{'hour'.pluralize(amount)}"
  end

  def send_verification_email
    HoursEntryMailer.verification(self).deliver
    self.update_attributes(:verification_sent_at => Time.now)
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

  private

  def user_entered?
    user_entered
  end

  def send_verified_email
    HoursEntryMailer.verified(self).deliver if newly_verified?
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

  def link_to_months
    dates.split(", ").each do |month|
      split_month = month.split(". ")
      month_name = split_month.first
      month_year = split_month.last.to_i

      if valid_month?(month_name) && month_year > 0
        month = Month.where(:name => month_name, :year => month_year)
        if month.empty?
          month = Month.create(
            :name => month_name,
            :year => month_year,
            :as_date => DateTime.strptime("#{month_year}-#{month_name}", "%Y-%b")
          )
        end
        self.months << month
      end
    end
  end

  def valid_month?(month)
    valid_months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    return valid_months.include?(month)
  end
end


