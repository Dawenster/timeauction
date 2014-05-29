class RewardsController < ApplicationController
  def show
    respond_to do |format|
      format.json { render :json => { :result => render_to_string(:partial => 'layouts/bid.html.slim', :locals => { :id => params[:id] }).html_safe } }
    end
  end

  def not_started
    respond_to do |format|
      format.json { render :json => { :result => render_to_string(:partial => 'layouts/not_started_modal.html.slim', :locals => { :id => params[:reward_id] }).html_safe } }
    end
  end

  def update
    respond_to do |format|
      begin
        @reward = Reward.find(params[:id])
        unless params[:first_name].blank? && params[:last_name].blank?
          current_user.first_name = params[:first_name] if params[:first_name]
          current_user.last_name = params[:last_name] if params[:last_name]
          current_user.save
        end
        maxed = @reward.maxed_out?
        @reward.users << current_user
        begin
          if maxed
            flash[:notice] = "Thank you! You have been placed on the waitlist for '#{@reward.title}'"
            BidMailer.waitlist_bid(@reward, current_user).deliver
            BidMailer.notify_admin(@reward, current_user, "Waitlist").deliver
          else
            flash[:notice] = "Thank you! You have successfully bid on the auction: #{@reward.auction.title}"
            create_hours_entry(@reward) if params[:use_stored_hours] == "true"
            BidMailer.successful_bid(@reward, current_user).deliver
            BidMailer.notify_admin(@reward, current_user, "Successful").deliver
          end
          format.json { render :json => { :url => request.referrer } }
        rescue
          format.json { render :json => { :url => request.referrer } }
          BidMailer.notify_admin(@reward, current_user, "Error sending user email - but still successful").deliver
        end
      rescue
        flash[:alert] = "Sorry, something went wrong and your bid didn't go through. Please try again!"
        format.json { render :json => { :url => request.referrer, :fail => true } }
      end
    end
  end

  private

  def create_hours_entry(reward)
    hours_entry = HoursEntry.new(
      :amount => reward.amount * -1,
      :user_id => current_user.id,
      :bid_id => current_user.bids.last.id
    )
    hours_entry.save(:validate => false)
  end
end