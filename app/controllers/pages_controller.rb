class PagesController < ApplicationController
  def landing
    @recent_auctions = Auction.order("created_at DESC").limit(3)
    @featured_auctions = (Auction.all - @recent_auctions).sample(3)
  end
end