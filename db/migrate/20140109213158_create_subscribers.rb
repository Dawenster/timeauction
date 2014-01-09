class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email
      t.integer :user_id

      t.timestamps
    end
  end
end
