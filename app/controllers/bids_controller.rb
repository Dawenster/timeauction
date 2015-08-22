class BidsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_view_permission, :only => [:bid]
  before_filter :check_at_max_bid, :only => [:bid]
  # before_filter :check_if_already_made_guaranteed_bid, :only => [:bid]
  
  def bid
    @auction = Auction.find(params[:auction_id])
    @reward = Reward.find(params[:reward_id])
    @hours_already_bid = @reward.hours_already_bid_by(current_user)
    @bid = Bid.new
    @bid.hours_entries.build
  end

  def create
    respond_to do |format|
      begin
        reward = Reward.find(params[:reward_id])
        auction = reward.auction

        add_name(params) unless already_has_name?(params)

        reward.users << current_user
        bid = current_user.bids.last
        bid.assign_attributes(bid_params)

        begin
          hk = params[:hk_domain] == "true"
          if hk
            bid.save(:validate => false) # HK does not create positive hours entry at time of bid
            # bid.hours_entries.last.destroy
          else
            if bid.save
              bid.update_mailchimp("Bidder")
              bid.update_attributes(:premium => true) if current_user.premium_and_valid?# && !reward.maxed_out?
              create_hours_entry(params[:hours_bid].to_i, bid.id, auction)
            else
              flash[:alert] = "Oops! Something went wrong with your bid... try again, or please email us!"
              format.json { render :json => { :url => bid_path(auction, reward), :fail => true } }
            end
          end
          bid.reload # To catch the used hours entries that got added above

          BidMailer.successful_bid(bid, current_user, hk).deliver
          BidMailer.notify_admin(reward, current_user, "Successful", hk).deliver
          flash[:notice] = "Thank you! You have successfully bid on the auction: #{auction.title}"
          format.json { render :json => { :url => auction_path(auction) } }
        rescue
          format.json { render :json => { :url => auction_path(auction) } }
          BidMailer.notify_admin(reward, current_user, "Error sending user email - but still successful", params[:hk_domain] == "true").deliver
        end
      rescue
        flash[:alert] = "Sorry, something went wrong and your bid didn't go through. Please try again!"
        format.json { render :json => { :url => auction_path(auction), :fail => true } }
      end
    end
  end

  def admin_send_confirmation_email
    bid = Bid.find(params[:id])
    begin
      bid.send_confirmation_email
    rescue => error
      flash[:alert] = error
    end
    redirect_to admin_bids_path
  end

  def admin_send_waitlist_email
    bid = Bid.find(params[:id])
    begin
      bid.send_waitlist_email
    rescue => error
      flash[:alert] = error
    end
    redirect_to admin_bids_path
  end

  private

  def bid_params
    params.require(:bid).permit(
      :application,
      :message,
      :premium,
      :winning,
      :enter_draw,
      :_destroy,
      hours_entries_attributes: [
        :id,
        :amount,
        :organization,
        :contact_name,
        :contact_phone,
        :contact_email,
        :contact_position,
        :description,
        :user_id,
        :dates,
        :user_entered,
        :_destroy
      ]
    )
  end

  def already_has_name?(params)
    params[:first_name].blank? && params[:last_name].blank? && params[:phone_number].blank?
  end

  def add_name(params)
    current_user.first_name = params[:first_name] if params[:first_name]
    current_user.last_name = params[:last_name] if params[:last_name]
    current_user.phone_number = params[:phone_number] if params[:phone_number]
    current_user.save
  end

  def create_hours_entry(amount_to_use, bid_id, auction)
    date = current_user.eligible_start_date(auction)
    while date < auction.volunteer_end_date do
      hours_bid = current_user.hours_available_during(date)

      if hours_bid > 0 && amount_to_use > 0
        hours_entry = HoursEntry.new(
          :amount => [amount_to_use, hours_bid].min * -1,
          :user_id => current_user.id,
          :bid_id => bid_id,
          :month => date.month,
          :year => date.year,
          :verified => true
        )
        hours_entry.save(:validate => false)

        if amount_to_use > hours_bid
          amount_to_use -= hours_bid
        else
          amount_to_use = 0
        end
      end

      date += 1.month
    end
  end

  def check_if_already_made_guaranteed_bid
    auction = Auction.find(params[:auction_id])
    reward = Reward.find(params[:reward_id])
    if reward.already_guaranteed_bid_by?(current_user)
      flash[:alert] = "You have already made a guaranteed bid on this reward!"
      redirect_to auction_path(auction)
    end
  end

  def check_view_permission
    auction = Auction.find(params[:auction_id])
    if auction.program
      unless current_user.admin || organization_match?(auction)
        organization = auction.program.organization
        flash[:alert] = "Sorry! Only #{organization.name} #{organization.people_descriptor} can bid on this auction. Check your organization settings #{view_context.link_to 'here', '#', :target => '_blank', 'data-reveal-id' => 'select-organization-modal', 'data-reveal' => ''}.".html_safe
        redirect_to request.referrer || auction_path(auction) || auctions_path
      end
    end
  end

  def check_at_max_bid
    reward = Reward.find(params[:reward_id])
    if current_user && current_user.already_at_max_bid?(reward, max_bid)
      unless current_user.admin
        flash[:alert] = "Sorry! You have already bid the maximum amount!".html_safe
        redirect_to request.referrer || auction_path(reward.auction) || auctions_path
      end
    end
  end

  def organization_match?(auction)
    current_user.organizations.include?(auction.program.organization)
  end
end