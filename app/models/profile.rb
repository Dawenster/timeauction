class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.profile_fields
    return {
      "ey" => [
        {
          :label => "Employee number",
          :name => "employee_number",
          :required => false
        },
        {
          :label => "Department",
          :name => "department",
          :required => false
        }
      ],

      "tesla" => [
        {
          :label => "Employee number",
          :name => "employee_number",
          :required => false
        },
        {
          :label => "Department",
          :name => "department",
          :required => false
        }
      ],
      
      "utsc" => [
        {
          :label => "Degree",
          :name => "degree",
          :required => false
        },
        {
          :label => "Year",
          :name => "year",
          :required => false
        }
      ],

      "sauder" => [
        {
          :label => "Program",
          :name => "program",
          :required => true
        },
        {
          :label => "Grad year",
          :name => "grad_year",
          :required => true
        },
        {
          :label => "Student number",
          :name => "student_number",
          :required => false
        }
      ]
    }
  end
end