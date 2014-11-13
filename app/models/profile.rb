class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.profile_fields
    return {
      "ey" => [
        {
          :label => "Department",
          :name => "department",
          :type => "text",
          :required => true
        }
      ],

      "sauder" => [
        {
          :label => "Program",
          :name => "program",
          :type => "select",
          :select_options => [
            "BCom",
            "MBA",
            "MM",
            "MMOR",
            "DULE",
            "DAP",
            "IMBA",
            "EMBA",
            "PhD",
            "Other"
          ],
          :required => true
        },
        {
          :label => "Grad year",
          :name => "grad_year",
          :type => "text",
          :required => true
        },
        {
          :label => "Student number",
          :name => "student_number",
          :type => "text",
          :required => false
        }
      ],

      "tesla" => [
        {
          :label => "Employee number",
          :name => "employee_number",
          :type => "text",
          :required => false
        },
        {
          :label => "Department",
          :name => "department",
          :type => "text",
          :required => false
        }
      ],
      
      "utsc" => [
        {
          :label => "Degree",
          :name => "degree",
          :type => "text",
          :required => false
        },
        {
          :label => "Year",
          :name => "year",
          :type => "text",
          :required => false
        }
      ]
    }
  end
end