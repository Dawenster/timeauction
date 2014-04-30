class BidsController < ApplicationController
  def bid
    @auction = Auction.find(params[:auction_id])
    @reward = Reward.find(params[:reward_id])
    @hours_entry = HoursEntry.new
  end

  def create
    
  end
end