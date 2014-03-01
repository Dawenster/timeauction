require 'spec_helper'

describe User do


  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  set(:user) { FactoryGirl.create :user, :first_name => nil, :last_name => nil }

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
      time = Time.utc(2015, "jan", 10, 0, 0, 0)
      user.update_attributes(:upgrade_date => time, :premium => true)
    end

    it "#premium_expire_date" do
      expect(user.premium_expire_date).to eq(Time.utc(2016, "jan", 10, 0, 0, 0))
    end

    it "#formatted_premium_expire_date" do
      expect(user.formatted_premium_expire_date).to eq("Jan 10, 2016")
    end

    context "#premium_still_valid?" do
      it "is valid" do
        time_now = Time.parse("Jan 09 2016")
        Time.stub!(:now).and_return(time_now)
        expect(user.premium_still_valid?).to eq(true)
      end

      it "is not valid" do
        time_now = Time.parse("Jan 11 2016")
        Time.stub!(:now).and_return(time_now)
        expect(user.premium_still_valid?).to eq(false)
      end
    end

    context "#premium_and_valid?" do
      it "is premium and valid" do
        time_now = Time.parse("Jan 09 2016")
        Time.stub!(:now).and_return(time_now)
        expect(user.premium_and_valid?).to eq(true)
      end

      it "is not premium or valid" do
        time_now = Time.parse("Jan 11 2016")
        Time.stub!(:now).and_return(time_now)
        expect(user.premium_and_valid?).to eq(false)
      end
    end
  end
end
