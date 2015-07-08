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
    Nonprofit.limit(5).map do |n|
      [n.name, n.id]
    end
  end
end