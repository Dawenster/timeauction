require 'spec_helper'

describe User do


  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  set(:user) { FactoryGirl.create :user }

  context "when signed in" do
    it "displays first and last name" do
      user.update_attributes(:first_name => "Happy", :last_name => "Volunteer")
      expect(user.display_name).to eq("Happy Volunteer")
    end

    it "displays username when missing first and last name" do
      expect(user.display_name).to eq(user.username)
    end
  end

  context "when registering" do
    # set(:user) { FactoryGirl.create :user, :username => "hApPy DuDe!" }

    it "parameterizes username" do
      user.update_attributes(:username => "hApPy DuDe!")
      expect(user.username).to eq("happy-dude")
    end
  end

  context "premium account" do
    before do
      time = Time.utc(2015, "jan", 1, 0, 0, 0)
      user.update_attributes(:upgrade_date => time)
    end

    it "#premium_expire_date" do
      expect(user.premium_expire_date).to eq(Time.utc(2016, "jan", 1, 0, 0, 0))
    end

    it "#formatted_premium_expire_date" do
      expect(user.formatted_premium_expire_date).to eq("Jan 01, 2016")
    end
  end
end
