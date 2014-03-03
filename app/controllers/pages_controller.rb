class PagesController < ApplicationController
  def landing
    @featured_auctions = Auction.where(:featured => true).sample(3)
  end

  def donors
    @sample_auction_1 = Auction.find(15)
    @sample_auction_2 = Auction.find(16)
    @sample_auction_3 = Auction.find(8)
  end
end