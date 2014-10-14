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
end