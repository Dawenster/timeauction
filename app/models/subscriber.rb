class Subscriber < ActiveRecord::Base
  belongs_to :user

  scope :unique, -> { count('email', :distinct => true) }

  def add_to_mailchimp
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => ENV["MAILCHIMP_ENGAGED_NETWORK_LIST_ID"],
      :email => {
        :email => self.email
      },
      :merge_vars => {
        "MMERGE3" => "Subscriber"
      },
      :double_optin => false,
      :update_existing => true
    })
  end

  def self.subscribers_with_accounts
    subscriber_emails = Subscriber.pluck(:email)
    user_emails = User.pluck(:email)
    return user_emails & subscriber_emails
  end

  def self.num_subscribers_without_accounts
    return Subscriber.unique - Subscriber.subscribers_with_accounts.count
  end
end