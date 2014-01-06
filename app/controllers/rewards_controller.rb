class RewardsController < ApplicationController
  def show
    respond_to do |format|
      format.json { render :json => { :result => render_to_string(:partial => 'layouts/bid.html.slim', :locals => { :id => params[:id] }).html_safe } }
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
      @reward.users << current_user
      format.json { render :json => { :url => request.referrer } }
    end
  end
end