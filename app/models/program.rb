class Program < ActiveRecord::Base
  belongs_to :organization
  has_many :auctions

  validates :name, :description, :organization_id, presence: true

  def text_with_organization
    "#{self.organization.name}: #{self.name}"
  end
end