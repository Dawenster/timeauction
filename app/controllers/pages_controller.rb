class PagesController < ApplicationController
  include UserTestimonialHelper
  include MediaHelper

  def landing
    @featured_auctions = Auction.where(:featured => true).custom_order
    @media_logos = popular_logos
    @testimonials = user_testimonials.sample(2)

    unless hk_domain?
      flash.now[:notice] ||= "Time Auction expands mission to make corporate volunteering awesome - #{view_context.link_to 'read more', corporate_path, :class => 'landing-corporate-flash'}"
    end
  end

  def testimonials
    @testimonials = user_testimonials
    @tweets = tweets
  end

  def donors
    @sample_auctions = Auction.where(:on_donor_page => true)
    @media_logos = popular_logos
  end

  def media
    @links = links
    @logos = logos
    @news = news
  end
end