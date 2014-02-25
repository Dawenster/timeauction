class PagesController < ApplicationController
  def landing
    @featured_auctions = Auction.where(:featured => true).sample(3)
  end
end