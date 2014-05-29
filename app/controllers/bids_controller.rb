class BidsController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :check_if_already_made_guaranteed_bid, :only => [:bid]
  
  def bid
    @auction = Auction.find(params[:auction_id])
    @reward = Reward.find(params[:reward_id])
    @hours_already_bid = @reward.hours_already_bid_by(current_user)
    @hours_entry = HoursEntry.new
    @bid = Bid.new
  end

  def create
    respond_to do |format|
      begin
        reward = Reward.find(params[:reward_id])
        auction = reward.auction

        unless params[:first_name].blank? && params[:last_name].blank? && params[:phone_number].blank?
          current_user.first_name = params[:first_name] if params[:first_name]
          current_user.last_name = params[:last_name] if params[:last_name]
          current_user.phone_number = params[:phone_number] if params[:phone_number]
          current_user.save
        end

        reward.users << current_user
        bid = current_user.bids.last
        bid.update_attributes(bid_params)
        bid.update_attributes(:premium => true) if current_user.premium_and_valid?# && !reward.maxed_out?

        begin
          if params[:use_stored_hours] == "true"
            create_hours_entry(params[:amount].to_i)
          else
            unless params[:hk_domain] == "true"
              hours_entry = HoursEntry.find(params[:hours_entry_id])
              create_hours_entry(hours_entry.amount)
            end
          end

          # if bid.premium
          #   BidMailer.successful_premium_bid(bid, current_user).deliver
          # else
          BidMailer.successful_bid(bid, current_user, params[:hk_domain] == "true").deliver
          # end

          BidMailer.notify_admin(reward, current_user, "Successful", params[:hk_domain] == "true").deliver
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

  private

  def bid_params
    params.require(:bid).permit(
      :application,
      :message,
      :premium
    )
  end

  def create_hours_entry(amount_to_use)
    hours_entry = HoursEntry.new(
      :amount => amount_to_use * -1,
      :user_id => current_user.id,
      :bid_id => current_user.bids.last.id
    )
    hours_entry.save(:validate => false)
  end

  def check_if_already_made_guaranteed_bid
    auction = Auction.find(params[:auction_id])
    reward = Reward.find(params[:reward_id])
    if reward.already_guaranteed_bid_by?(current_user)
      flash[:alert] = "You have already made a guaranteed bid on this reward!"
      redirect_to auction_path(auction)
    end
  end
end