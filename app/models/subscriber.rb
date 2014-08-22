class Subscriber < ActiveRecord::Base
  belongs_to :user

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
end