class UsersController < ApplicationController  
  before_filter :authenticate_user!, :except => [:show]

  def show
    @user = User.find(params[:id])
    @roles = @user.ordered_roles
    @donations = @user.grouped_donations
    @participated_auctions = @user.rewards.order("created_at DESC").map{ |reward| reward.auction }.uniq
    @activities = @user.activities_by_date
  end

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
      # if params[:billingPeriod] == "annual"
      #   plan = "annual-84"
      # else
      #   plan = "monthly-10"
      # end
      plan = "supporter"

      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        if current_user.stripe_cus_id
          customer = Stripe::Customer.retrieve(current_user.stripe_cus_id)
          customer.subscriptions.create(:plan => plan)
        else
          customer = Stripe::Customer.create(
            :card => token,
            :plan => plan,
            :email => current_user.email
          )
        end
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        puts "STRIPE ERROR: #{e.message}"
      end

      begin
        current_user.update_attributes(
          :premium => true,
          :upgrade_date => Time.now,
          :stripe_cus_id => customer.id
        )

        UpgradeMailer.notify_user_of_upgrade(current_user).deliver
        UpgradeMailer.notify_admin(current_user, "Successfully upgraded").deliver

        flash[:notice] = "Thank you for upgrading, you are now a Time Auction Supporter"
      rescue
        if current_user.premium_and_valid?
          flash[:notice] = "Thank you for upgrading, you are now a Time Auction Supporter"
          UpgradeMailer.notify_admin(current_user, "Upgraded but mailer failed").deliver
        else
          flash[:alert] ||= "Sorry, something went wrong and you were not upgraded. We will reach out to you shortly to rectify."
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

  def cancel_subscription
    begin
      customer = Stripe::Customer.retrieve(current_user.stripe_cus_id)
      subscription = customer.subscriptions.first.id
      customer.subscriptions.retrieve(subscription).delete()
      current_user.update_attributes(:premium => false, :upgrade_date => nil)
      flash[:notice] = "Your Supporter Status has been cancelled. You now have a General Account."
      redirect_to edit_user_registration_path
    rescue
      flash[:alert] = "Sorry, something went wrong and your Supporter Status was not cancelled.  Please email us at team@timeauction.org."
      redirect_to edit_user_registration_path
    end
  end

  def save_about
    respond_to do |format|
      current_user.update_attributes(:about => params[:aboutText])
      format.json { render :json => { :data => current_user.about } }
    end
  end

  def update_credit_card
    respond_to do |format|
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:token]["id"]
      begin
        customer = Stripe::Customer.retrieve(current_user.stripe_cus_id)
        customer.sources.retrieve(params[:cardId]).delete
        customer.sources.create(:source => token)

        flash[:notice] = "You have successfully updated your card"
        format.json { render :json => { :status => "success" } }
      rescue Stripe::CardError => e
        flash[:notice] = e
        format.json { render :json => { :status => "error" } }
      end
    end
  end

  def delete_credit_card
    respond_to do |format|
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      begin
        customer = Stripe::Customer.retrieve(current_user.stripe_cus_id)
        customer.sources.retrieve(params[:card_id]).delete

        flash[:notice] = "You have successfully deleted your card"
        format.json { render :json => { :status => "success" } }
      rescue Stripe::CardError => e
        flash[:notice] = e
        format.json { render :json => { :status => "error" } }
      end
    end
  end
end