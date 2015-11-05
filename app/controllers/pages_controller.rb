class PagesController < ApplicationController
  include UserTestimonialHelper
  include MediaHelper
  include FaqHelper

  def landing
    # @media_logos = popular_logos
    # @testimonials = user_testimonials.sample(2)
    @featured_auctions = Auction.where(:featured => true).custom_order
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

  def named_share
    case params[:name]
    when "robert"
      @auction = Auction.find(277)
      @twitter_handle = "@theRealKiyosaki"
      @bitly = 'bit.ly/1gUyEYs'
    when "jon"
      @auction = Auction.find(276)
      @twitter_handle = "@Reichental"
      @bitly = 'bit.ly/1EDlXae'
    when "tony"
      @auction = Auction.find(155)
      @twitter_handle = "@TonyLacavera"
      @bitly = 'bit.ly/1MKuDnc'
    else
      redirect_to share_path
    end
  end
end