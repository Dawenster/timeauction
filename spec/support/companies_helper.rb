def fill_in_company_fields
  fill_in :company_name, :with => "Nike"
  fill_in :company_url, :with => "nike"
  fill_in :company_email_domains_attributes_0_domain, :with => "nike.com"
end

def make_email(company)
  "johndoe@#{company.email_domains.first.domain}"
end