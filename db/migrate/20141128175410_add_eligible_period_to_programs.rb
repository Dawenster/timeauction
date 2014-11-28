class AddEligiblePeriodToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :eligible_period, :string
  end
end
