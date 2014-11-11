class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.profile_fields
    return {
      "ey" => [
        {
          :label => "Employee number",
          :name => "employee_number"
        },
        {
          :label => "Department",
          :name => "department"
        }
      ],

      "tesla" => [
        {
          :label => "Employee number",
          :name => "employee_number"
        },
        {
          :label => "Department",
          :name => "department"
        }
      ],
      
      "utsc" => [
        {
          :label => "Degree",
          :name => "degree"
        },
        {
          :label => "Year",
          :name => "year"
        }
      ],

      "sauder" => [
        {
          :label => "Program",
          :name => "program"
        },
        {
          :label => "Grad year",
          :name => "grad_year"
        },
        {
          :label => "Student number",
          :name => "student_number"
        }
      ]
    }
  end
end