class RenameStartAndEndOnAuctions < ActiveRecord::Migration
  def change
    rename_column :auctions, :start, :start_time
    rename_column :auctions, :end, :end_time
  end
end
