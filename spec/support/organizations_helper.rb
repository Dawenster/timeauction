def fill_in_organization_fields
  fill_in :organization_name, :with => "Nike"
  fill_in :organization_url, :with => "nike"
  fill_in :organization_people_descriptor, :with => "peeps"
  fill_in :organization_email_domains_attributes_0_domain, :with => "nike.com"
end

def make_email(organization)
  "johndoe@#{organization.email_domains.first.domain}"
end