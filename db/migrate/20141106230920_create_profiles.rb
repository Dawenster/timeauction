class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :program
      t.string :year
      t.string :student_number
    end
  end
end
