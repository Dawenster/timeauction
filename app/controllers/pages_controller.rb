class PagesController < ApplicationController
  include UserTestimonialHelper
  include MediaHelper
  include FaqHelper

  def landing
    # @media_logos = popular_logos
    # @testimonials = user_testimonials.sample(2)
    @featured_auctions = Auction.not_corporate.where(:featured => true).custom_order
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
      if params[:auctionId]
        @featured_auctions = @featured_auctions - [Auction.find(params[:auctionId])]
      end
      format.js
    end
  end

  def faq
    @sections = sections
  end
end