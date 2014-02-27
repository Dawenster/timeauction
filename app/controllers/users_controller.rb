class UsersController < ApplicationController  
  def upgrade
    respond_to do |format|
      current_user.update_attributes(:premium => true)
      format.json { render :json => {} }
    end
  end

  def check_user_premium
    respond_to do |format|
      format.json { render :json => { :result => current_user.premium } }
    end
  end
end