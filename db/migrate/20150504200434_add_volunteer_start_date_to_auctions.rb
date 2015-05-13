class AddVolunteerStartDateToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :volunteer_start_date, :datetime
  end
end
