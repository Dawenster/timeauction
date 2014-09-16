class AddProgramIdToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :program_id, :integer
  end
end
