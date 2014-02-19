class PagesController < ApplicationController
  def landing
    @recent_auctions = Auction.where(:submitted => true, :approved => true).order("created_at DESC").limit(3)
    @featured_auctions = (Auction.where(:submitted => true, :approved => true) - @recent_auctions).sample(3)
  end
end