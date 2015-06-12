class DonationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    respond_to do |format|
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:token]["id"]

      begin
        if current_user.stripe_cus_id
          customer_id = current_user.stripe_cus_id
        else
          # Create a Customer
          customer = Stripe::Customer.create(
            :source => token,
            :description => current_user.display_name
          )
          customer_id = customer.id
        end

        # Charge the Customer instead of the card
        charge = Stripe::Charge.create(
          :amount => params[:amount].to_i, # in cents
          :currency => "CAD",
          :customer => customer_id,
          :description => "Donation to #{params[:charity_name]}"
        )

        # Save the customer ID in your database so you can use it later
        save_stripe_customer_id(customer_id)

        # Save donation to database
        Donation.create(
          :stripe_charge_id => charge["id"],
          :amount => charge["amount"],
          :tip => params["tip"].to_f.round,
          :nonprofit_id => params["charity_id"],
          :user_id => current_user.id
        )
        format.json { render :json => { :message => "Donation made successfully", :status => "success" } }
      rescue Stripe::CardError => e
        # The card has been declined
        format.json { render :json => { :message => e, :status => "error" } }
      end
    end
  end

  def save_stripe_customer_id(cus_id)
    current_user.update_attributes(:stripe_cus_id => cus_id)
  end
end