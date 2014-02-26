class UsersController < ApplicationController  
  def upgrade
    respond_to do |format|
      format.json { render :json => { :result => render_to_string(:partial => 'layouts/upgrade_account.html.slim', :locals => { :id => params[:reward_id] }).html_safe } }
    end
  end
end