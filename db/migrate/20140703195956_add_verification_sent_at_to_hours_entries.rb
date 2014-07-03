class AddVerificationSentAtToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :verification_sent_at, :datetime
  end
end
