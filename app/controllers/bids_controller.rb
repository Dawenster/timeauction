class BidsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_view_permission, :only => [:bid]
  before_filter :check_at_max_bid, :only => [:bid]
  # before_filter :check_if_already_made_guaranteed_bid, :only => [:bid]
  
  def bid
    @auction = Auction.find(params[:auction_id])
    @reward = Reward.find(params[:reward_id])
    @hours_already_bid = @reward.hours_already_bid_by(current_user)
    @donation = Donation.new
    if current_user.stripe_cus_id
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      begin
        customer = Stripe::Customer.retrieve(current_user.stripe_cus_id)
        @default_card = customer.sources.retrieve(customer.default_card)
      rescue
        # If a similar Stripe object exists in live mode, but a test mode key was used to make this request.
        @default_card = nil
      end
    end
  end

  def create
    respond_to do |format|
      begin
        reward = Reward.find(params[:reward_id])
        auction = reward.auction
        add_name(params) if user_changed_details?(params)
        reward.users << current_user
        hk = params[:hk_domain] == "true"

        bid = current_user.bids.last
        bid.update_mailchimp("Bidder") unless hk
        bid.update_attributes(:enter_draw => params[:enter_draw])
        bid.update_attributes(:premium => true) if current_user.premium_and_valid?
        create_hours_entries(params[:hours_bid].to_i, bid.id, auction)
        bid.reload # To catch the used hours entries that got added above

        begin
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

  def user_changed_details?(params)
    current_user.first_name != params[:first_name] || current_user.last_name != params[:last_name] || current_user.phone_number != params[:phone_number]
  end

  def add_name(params)
    current_user.first_name = params[:first_name] if params[:first_name]
    current_user.last_name = params[:last_name] if params[:last_name]
    current_user.phone_number = params[:phone_number] if params[:phone_number]
    current_user.save
  end

  def create_hours_entries(amount_to_use, bid_id, auction)
    earliest_start_date = current_user.eligible_start_date(auction)
    earliest_date_with_hours = current_user.earliest_month_with_hours_logged
    earliest_month_with_hours = Date.new(earliest_date_with_hours.year, earliest_date_with_hours.month, 1) # Create date object on the first of the month
    date = [earliest_start_date, earliest_month_with_hours].max

    while date < auction.volunteer_end_date do
      available_points = current_user.remaining_points_in(date)

      if available_points > 0 && amount_to_use > 0
        hours_entry = HoursEntry.new(
          :amount => 0,
          :points => [amount_to_use, available_points].min * -1,
          :user_id => current_user.id,
          :bid_id => bid_id,
          :month => date.month,
          :year => date.year,
          :verified => true
        )
        hours_entry.save(:validate => false)

        if amount_to_use > available_points
          amount_to_use -= available_points
        else
          amount_to_use = 0
        end
      end

      date += 1.month
    end

    # If no volunteer hours as karma, use up the rest in a negative donation for this month
    if amount_to_use > 0
      donation = Donation.create(
        :amount => amount_to_use * -100,
        :user_id => current_user.id,
        :bid_id => bid_id
      )
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