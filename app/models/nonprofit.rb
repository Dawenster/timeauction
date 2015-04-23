class Nonprofit < ActiveRecord::Base
  has_many :hours_entries
  has_many :users, :through => :roles

  validates :name, presence: true

  before_save :create_slug

  def create_slug
    self.slug = self.to_slug
  end

  def to_slug
    self.name.parameterize
  end
end