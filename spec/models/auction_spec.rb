  context "when registering" do
    let(:auction) { FactoryGirl.create :auction }
    let(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
    it "#hours_raised" do
      auction.rewards.each do |reward|
        reward.users << user
      end
      expect(auction.hours_raised).to eq(30)
    end
  end
end
