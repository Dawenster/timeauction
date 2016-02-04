task :mark_bids_as_winning => :environment do
  round_1_auctions = Auction.approved.where("created_at < ?", Time.utc(2014,"mar",23,0,0,0))

  round_1_auctions.each do |auction|
    auction.rewards.each do |reward|
      reward.bids.each do |bid|
        bid.update_attributes(:winning => true) if bid.user.earned_reward?(reward)
      end
    end
  end

  Bid.find(22).update_attributes(:winning => true) # Jack Liu
  Bid.find(47).update_attributes(:winning => true) # Aviva Rudberg
  Bid.find(89).update_attributes(:winning => true) # Zina Nelku
  Bid.find(82).update_attributes(:winning => true) # Kaizza Mae Belen
  Bid.find(73).update_attributes(:winning => true) # Carrie Sullivan
  Bid.find(45).update_attributes(:winning => true) # Anne Marie Evans
  Bid.find(39).update_attributes(:winning => true) # Ken Horton

  round_2_auctions = Auction.approved.where("created_at > ?", Time.utc(2014,"mar",23,0,0,0))

  round_2_auctions.each do |auction|
    auction.rewards.each do |reward|
      reward.bids.each do |bid|
        bid.update_attributes(:winning => true)
      end
    end
  end
end

task :create_negative_entries_for_hk_bids => :environment do
  Bid.all.each do |bid|
    amount = bid.reward.amount
    hours_entry = HoursEntry.new(
      :amount => 0,
      :points => amount * -10,
      :user => bid.user,
      :bid => bid,
      :month => bid.created_at.month,
      :year => bid.created_at.year,
      :verified => true
    )
    hours_entry.save(:validate => false)
  end
end