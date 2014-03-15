require 'spec_helper'

describe HoursEntry do
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:entry_1) { FactoryGirl.create :hours_entry, :user_id => user.id }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:organization) }
  it { should validate_presence_of(:contact_name) }
  it { should validate_presence_of(:contact_phone) }
  it { should validate_presence_of(:contact_email) }

  it "#earned? verified" do
    entry_1.update_attributes(:verified => true)
    expect(entry_1.earned?).to eq(true)
  end

  it "#earned? not verified" do
    entry_1.update_attributes(:amount => -5)
    expect(entry_1.earned?).to eq(false)
  end
end