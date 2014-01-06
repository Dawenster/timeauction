class AddVolunteerEndDateToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :volunteer_end_date, :datetime
  end
end
