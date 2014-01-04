class RewardsController < ApplicationController
  def show
    respond_to do |format|
      format.json { render :json => { :result => render_to_string(:partial => 'layouts/bid.html.slim', :locals => { :id => params[:id] }).html_safe } }
    end
  end

  def update
    @reward = Reward.find(params[:id])
    @reward.users << current_user
    redirect_to request.referrer
  end
end