class PagesController < ApplicationController
  include UserTestimonialHelper
  include MediaHelper

  def landing
    @media_logos = popular_logos
    @testimonials = user_testimonials.sample(2)
    if hk_domain?
      if organization_user?
        @featured_auctions = current_user.current_auctions
      else
        @featured_auctions = Auction.not_corporate.where(:featured => true).custom_order
      end
    else
      if organization_user?
        auctions = current_user.current_auctions
      else
        auctions = Auction.not_corporate.approved.current_or_pending
        auctions = Auction.where(:featured => true).custom_order if auctions.empty?
      end
      @lucky_auction = auctions.sample
      @first_auction = auctions.first
    end
  end

  def testimonials
    @testimonials = user_testimonials
    @tweets = tweets
  end

  def donors
    @sample_auctions = Auction.not_corporate.where(:on_donor_page => true)
    @media_logos = popular_logos
  end

  def media
    @links = links
    @logos = logos
    @news = news
  end

  def donors_slider
    respond_to do |format|
      if organization_user?
        @featured_auctions = current_user.current_auctions
      else
        @featured_auctions = Auction.not_corporate.where(:featured => true).custom_order
      end
      @featured_auctions = @featured_auctions - [Auction.find(params[:auctionId])]
      format.js
    end
  end
end