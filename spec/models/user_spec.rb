require 'spec_helper'

describe User do

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  context "when signed in" do
    let(:user) { FactoryGirl.create :user }

    it "displays first and last name" do
      user.update_attributes(:first_name => "Happy", :last_name => "Volunteer")
      expect(user.display_name).to eq("Happy Volunteer")
    end

    it "displays username when missing first and last name" do
      expect(user.display_name).to eq(user.username)
    end
  end
end
