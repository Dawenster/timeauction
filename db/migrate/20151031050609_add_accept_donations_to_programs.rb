class AddAcceptDonationsToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :accept_donations, :boolean
  end
end
