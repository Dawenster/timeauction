task :draw, [:reward_id, :num_to_draw] => :environment do |t, args|
  reward = Reward.find(args.reward_id) # Find the reward object
  available_spots = reward.max # Number of available spots on the reward
  bids = reward.bids # Get all bids associated with this reward

  num_to_draw = args.num_to_draw # The specified number of winners to draw
  num_to_draw ||= available_spots # If not provided, then default to the number of spots available on the reward
  num_to_draw = num_to_draw.to_i # Making num_to_draw an integer

  if reward.num_bidders <= num_to_draw # If the number of bidders are less than the number of winners being drawn
    winners = reward.bidders # All bidders win
    console_output(winners)
  else
    winners = randomly_draw_winners(bids, num_to_draw) # Randomly draw winning bidders
    console_output(winners)
  end
end

def randomly_draw_winners(bids, num_to_draw)
  winners = [] # Create an empty array to hold all winners

  all_entries = collect_bid_ids(bids) # Get all the entries

  until winners.size == num_to_draw do # Until the number of winners equal the number we want to draw
    chosen_bid_id = all_entries.sample(1).first # Use Ruby's random array selector to select a bid
    bid = Bid.find(chosen_bid_id) # Find the bid object
    user = bid.user # The user that made the bid
    winners << user unless winners.include?(user) # Add winning user to winners holder unless user is already a winner
  end

  return winners
end

def collect_bid_ids(bids)
  all_entries = [] # Create an empty array to hold all the entries

  bids.each do |bid| # For each bid
    number_of_entries = bid.hours # Figure out how many hours were bid; one hour is equal to one entry

    number_of_entries.times do # For each entry
      all_entries << bid.id # Put one Bid ID into the all_entries holder
    end
  end

  return all_entries
end

def console_output(winners)
  winners.each do |winner|
    puts "#{winner.display_name}, ID: #{winner.id}"
  end
end