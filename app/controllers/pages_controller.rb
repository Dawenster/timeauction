class PagesController < ApplicationController
  include UserTestimonialHelper
  include MediaHelper

  def landing
    @media_logos = popular_logos
    @testimonials = user_testimonials.sample(2)
    if hk_domain?
      if organization_user?
        @featured_auctions = current_user.organization.current_auctions
      else
        @featured_auctions = Auction.not_corporate.where(:featured => true).custom_order
      end
    else
      if organization_user?
        @lucky_auction = current_user.organization.current_auctions.sample
      else
        @lucky_auction = Auction.not_corporate.current_or_pending.sample
      end
    end
    # unless hk_domain?
    #   flash.now[:notice] ||= "Time Auction expands mission to make corporate volunteering awesome - #{view_context.link_to 'read more', corporate_path, :class => 'landing-corporate-flash'}"
    # end
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
        @featured_auctions = current_user.organization.current_auctions
      else
        @featured_auctions = Auction.not_corporate.where(:featured => true).custom_order
      end
      format.js
    end
  end
end