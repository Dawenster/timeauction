class Profile < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  def self.create_or_update_for(org, fields, org_id, user)
    case org
    when "ey"
      Profile.create_or_update_for_ey(fields, org_id, user)
    when "sauder"
      Profile.create_or_update_for_sauder(fields, org_id, user)
    when "bclc"
      Profile.create_or_update_for_bclc(fields, org_id, user)
    when "utsc"
      Profile.create_or_update_for_utsc(fields, org_id, user)
    end
  end

  def self.create_or_update_for_ey(fields, org_id, user)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    user_profiles_for_this_org = user.profiles.where(:organization_id => org_id)
    if user_profiles_for_this_org.any?
      user_profiles_for_this_org.last.update_attributes(
        :department => fields["department"],
        :organization_id => org_id,
        :user_id => user.id
      )
    else
      Profile.create(
        :department => fields["department"],
        :organization_id => org_id,
        :user_id => user.id
      )
    end
  end

  def self.create_or_update_for_sauder(fields, org_id, user)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    user_profiles_for_this_org = user.profiles.where(:organization_id => org_id)
    if user_profiles_for_this_org.any?
      user_profiles_for_this_org.last.update_attributes(
        :program => fields["program"],
        :year => fields["grad_year"],
        :identification_number => fields["identification_number"],
        :organization_id => org_id,
        :user_id => user.id
      )
    else
      Profile.create(
        :program => fields["program"],
        :year => fields["grad_year"],
        :identification_number => fields["identification_number"],
        :organization_id => org_id,
        :user_id => user.id
      )
    end
  end

  def self.create_or_update_for_bclc(fields, org_id, user)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    user_profiles_for_this_org = user.profiles.where(:organization_id => org_id)
    if user_profiles_for_this_org.any?
      user_profiles_for_this_org.last.update_attributes(
        :location => fields["location"],
        :data_privacy => fields["data_privacy"],
        :organization_id => org_id,
        :user_id => user.id
      )
    else
      Profile.create(
        :location => fields["location"],
        :data_privacy => fields["data_privacy"],
        :organization_id => org_id,
        :user_id => user.id
      )
    end
  end

  def self.create_or_update_for_utsc(fields, org_id, user)
    fields = fields.values.reduce({}, :merge) # Remove numbers, merge array of hashes
    user_profiles_for_this_org = user.profiles.where(:organization_id => org_id)
    if user_profiles_for_this_org.any?
      user_profiles_for_this_org.last.update_attributes(
        :program => fields["program"],
        :year => fields["grad_year"],
        :data_privacy => fields["data_privacy"],
        :organization_id => org_id,
        :user_id => user.id
      )
    else
      Profile.create(
        :program => fields["program"],
        :year => fields["grad_year"],
        :data_privacy => fields["data_privacy"],
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
          :value => user.profile_for(org) ? user.profile_for(org).department : nil,
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
          :name => "identification_number",
          :type => "text",
          :value => user.profile_for(org) ? user.profile_for(org).identification_number : nil,
          :required => false
        }
      ],

      "bclc" => [
        {
          :label => "Location",
          :name => "location",
          :type => "select",
          :select_options => [
            "Kamloops",
            "Vancouver"
          ],
          :value => user.profile_for(org) ? user.profile_for(org).location : nil,
          :required => true
        },
        {
          :label => "Data privacy agreement",
          :name => "data_privacy",
          :type => "boolean",
          :boolean_text => "Your personal information will be collected in accordance with B.C.’s Freedom of Information and Protection of Privacy Act and will be used, accessed, disclosed and stored inside and outside of Canada for the purpose of administering the bid auctions and compiling information about volunteerism at BCLC. Effective on the date you sign up, you agree that your information may be used, accessed, disclosed and stored inside and outside of Canada for this purpose. Questions? Please contact david@timeauction.org",
          :checkbox_text => "  I consent",
          :value => user.profile_for(org) ? user.profile_for(org).data_privacy : nil,
          :required => true
        }
      ],

      "utsc" => [
        {
          :label => "Program",
          :name => "program",
          :type => "text",
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
          :label => "Data and privacy",
          :name => "data_privacy",
          :type => "boolean",
          :boolean_text => "Your activity on Time Auction may be shared with UTSC in aggregate form.",
          :checkbox_text => "  I consent",
          :value => user.profile_for(org) ? user.profile_for(org).data_privacy : nil,
          :required => true
        }
      ]
    }
  end
end