class Program < ActiveRecord::Base
  belongs_to :company
  has_many :auctions

  validates :name, :description, :company_id, presence: true
end