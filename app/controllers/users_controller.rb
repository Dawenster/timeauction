class UsersController < ApplicationController  
  def upgrade_details
    respond_to do |format|
      format.json {
        render :json => {
          :key => ENV['STRIPE_PUBLISHABLE_KEY'],
          :email => current_user.email,
          :url => upgrade_account_path
        }
      }
    end
  end

  def upgrade
    respond_to do |format|
      # Get the credit card details submitted by the form
      token = params[:stripeToken][:id]

      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        customer = Stripe::Customer.create(
          :card => token,
          :plan => "supporter",
          :email => current_user.email
        )
        
      rescue Stripe::CardError => e
        flash[:error] = e.message
        puts "STRIPE ERROR: #{e.message}"
      end

      begin
        current_user.update_attributes(
          :premium => true,
          :upgrade_date => Time.now
        )

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