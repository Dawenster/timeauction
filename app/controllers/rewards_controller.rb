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
      @reward = Reward.find(params[:id])
      unless params[:first_name].blank? && params[:last_name].blank?
        current_user.update_attributes(
          :first_name => params[:first_name],
          :last_name => params[:last_name]
        )
      end
      if @reward.maxed_out?
        flash[:alert] = "This reward has already reached its maximum allowed bidders."
      else
        flash[:notice] = "Thank you! You have successfully committed to the auction: #{@reward.auction.title}"
        @reward.users << current_user
      end
      format.json { render :json => { :url => request.referrer } }
    end
  end
end