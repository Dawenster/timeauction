class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.create_for(org, fields, org_id, user_id)
    case org
    when "sauder"
      Profile.create_for_sauder(fields, org_id, user_id)
    end
  end

  def self.create_for_sauder(fields, org_id, user_id)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    Profile.create(
      :program => fields["program"],
      :year => fields["grad_year"],
      :student_number => fields["student_number"],
      :organization_id => org_id,
      :user_id => user_id
    )
  end

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