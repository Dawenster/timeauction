class AddVolunteerOpportunitiesLinkToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :volunteer_opportunities_link, :string
  end
end
