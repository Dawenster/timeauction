class RenameStudentNumberToIdentificationNumber < ActiveRecord::Migration
  def change
    rename_column :profiles, :student_number, :identification_number
  end
end
