class UsersController < ApplicationController  
  def upgrade
    respond_to do |format|
      current_user.update_attributes(:premium => true, :upgrade_date => Time.now)
      UpgradeMailer.notify_user_of_upgrade(current_user).deliver
      UpgradeMailer.notify_admin(current_user).deliver
      format.json { render :json => {} }
    end
  end

  def check_user_premium
    respond_to do |format|
      format.json { render :json => { :result => current_user.premium_and_valid? } }
    end
  end
end