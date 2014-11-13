class Organization < ActiveRecord::Base
  has_many :users, :through => :profiles
  has_many :email_domains, :dependent => :destroy
  has_many :programs, :dependent => :destroy
  has_many :profiles
  accepts_nested_attributes_for :email_domains, :allow_destroy => true, :reject_if => proc { |att| att['domain'].blank? }

  before_save :mark_email_domains_for_removal

  validates :url, uniqueness: true
  validates :url, :name, :people_descriptor, presence: true

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :logo, 
                    :styles => { :thumb => "300x300#", :display => "540x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"

  has_attached_file :background_image,
                    :styles => { :thumb => "300x225#", :display => "720x540#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/timeauction/missing-auction-thumb.png"

  def current_auctions
    program_ids = self.programs.map{ |program| program.id }
    return Auction.where(:program_id => program_ids).approved.current.custom_order# + Auction.not_corporate.approved.current.custom_order
  end

  def pending_auctions
    program_ids = self.programs.map{ |program| program.id }
    return Auction.where(:program_id => program_ids).approved.pending.custom_order# + Auction.not_corporate.approved.pending.custom_order
  end

  def current_and_pending_auctions
    current_auctions + pending_auctions
  end

  def past_auctions
    program_ids = self.programs.map{ |program| program.id }
    return Auction.where(:program_id => program_ids).approved.past.custom_order# + Auction.not_corporate.approved.past.custom_order
  end

  def self.organizations_to_select
    orgs = []
    profile_fields = Profile.profile_fields
    Organization.all.map do |org|
      next if org.draft
      capitalized_people_descriptor = org.people_descriptor.slice(0,1).capitalize + org.people_descriptor.slice(1..-1)
      orgs << {
        :logo => org.logo.url(:thumb),
        :name => org.name,
        :people_descriptor => capitalized_people_descriptor,
        :url => org.url,
        :fields => profile_fields[org.url]
      }
    end
    return orgs
  end

  private

  def mark_email_domains_for_removal 
    self.email_domains.each do |email_domain|
      email_domain.mark_for_destruction if email_domain.domain.blank?
    end 
  end
end