class CreateHoursEntries < ActiveRecord::Migration
  def change
    create_table :hours_entries do |t|
      t.integer :amount
      t.string :organization
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.string :contact_position
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
