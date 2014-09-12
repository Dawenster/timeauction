class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :url
      t.attachment :logo
      t.attachment :background_image

      t.timestamps
    end
  end
end
