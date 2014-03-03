class UsersController < ApplicationController  
  def upgrade
    respond_to do |format|
      begin
        current_user.update_attributes(:premium => true, :upgrade_date => Time.now)
        UpgradeMailer.notify_user_of_upgrade(current_user).deliver
        UpgradeMailer.notify_admin(current_user, "Successfully upgraded").deliver
        flash[:notice] = "Thank you for upgrading, you are now a Time Auction Supporter"
      rescue
        if current_user.premium_and_valid?
          flash[:notice] = "Thank you for upgrading, you are now a Time Auction Supporter"
          UpgradeMailer.notify_admin(current_user, "Upgraded but mailer failed").deliver
        else
          flash[:alert] = "Sorry, something went wrong and you were not upgraded. We will reach out to you shortly to rectify."
          UpgradeMailer.notify_admin(current_user, "FAILED TO UPGRADE!").deliver
        end
      end
      format.json { render :json => { :url => request.referrer } }
    end
  end

  def check_user_premium
    respond_to do |format|
      format.json { render :json => { :result => current_user.premium_and_valid?, :user_id => current_user.id } }
    end
  end
end