class Nonprofit < ActiveRecord::Base
  has_many :hours_entries
  has_many :roles
  has_many :users, -> { uniq }, :through => :roles
  has_many :donations

  validates :name, presence: true

  before_save :create_slug

  def create_slug
    self.slug = self.to_slug
  end

  def to_slug
    self.name.parameterize
  end

  def self.find_by_slug_or_create(name)
    return Nonprofit.find_by_slug(name.parameterize) || Nonprofit.create(:name => name.strip)
  end

  def self.donations_select
    if Rails.env.test?
      nonprofits = Nonprofit.limit(5)
    else
      nonprofits = [
        Nonprofit.find(460), # International Red Cross
        Nonprofit.find(462), # Against Malaria Foundation
        Nonprofit.find(358), # BC Children's Hospital
        Nonprofit.find(461), # SickKids Hospital
        Nonprofit.find(387), # CBCF
        Nonprofit.find(354)  # BC SPCA
      ]
    end
    nonprofits.map do |n|
      [n.name, n.id]
    end
  end
end