class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.create_or_update_for(org, fields, org_id, user)
    case org
    when "sauder"
      Profile.create_or_update_for_sauder(fields, org_id, user)
    end
  end

  def self.create_or_update_for_sauder(fields, org_id, user)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    if user.profiles.any?
      user.profiles.last.update_attributes(
        :program => fields["program"],
        :year => fields["grad_year"],
        :student_number => fields["student_number"],
        :organization_id => org_id,
        :user_id => user.id
      )
    else
      Profile.create(
        :program => fields["program"],
        :year => fields["grad_year"],
        :student_number => fields["student_number"],
        :organization_id => org_id,
        :user_id => user.id
      )
    end
  end

  def self.profile_fields(user, org)
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
          :value => user.profile_for(org) ? user.profile_for(org).program : nil,
          :required => true
        },
        {
          :label => "Grad year",
          :name => "grad_year",
          :type => "text",
          :value => user.profile_for(org) ? user.profile_for(org).year : nil,
          :required => true
        },
        {
          :label => "Student number",
          :name => "student_number",
          :type => "text",
          :value => user.profile_for(org) ? user.profile_for(org).student_number : nil,
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