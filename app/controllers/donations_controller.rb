class DonationsController < ApplicationController
  # before_filter :authenticate_user!

  def create
    respond_to do |format|
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:token]

      if params[:is_signed_in] == "true"
        user = current_user
      else
        user = create_and_sign_in_user
      end

      begin
        if user.stripe_cus_id
          # Retrieve customer
          customer = Stripe::Customer.retrieve(user.stripe_cus_id)
          update_card_if_new(customer, token[:id]) unless token.blank?
        else
          # Create a Customer
          customer = Stripe::Customer.create(
            :source => token[:id],
            :description => user.display_name
          )

          # Save the customer ID in your database so you can use it later
          save_stripe_customer_id(customer.id, user)
        end

        # Charge the Customer instead of the card
        charge = Stripe::Charge.create(
          :amount => params[:amount].to_i, # in cents
          :currency => "CAD",
          :customer => customer.id,
          :description => "Donation to #{params[:charity_name]}"
        )

        # Save donation to database
        Donation.create(
          :stripe_charge_id => charge[:id],
          :amount => charge[:amount],
          :tip => params[:tip].to_f.round,
          :nonprofit_id => params[:charity_id],
          :user_id => user.id
        )

        flash[:notice] = "You have successfully added Karma Points"
        format.json { render :json => { :result => "Donation made successfully", :status => "success" } }
      rescue Stripe::CardError => e
        # The card has been declined
        format.json { render :json => { :result => e, :status => "error" } }
      end
    end
  end

  def save_stripe_customer_id(cus_id, user)
    user.update_attributes(:stripe_cus_id => cus_id)
  end

  def update_card_if_new(customer, token)
    # Create card if don't currently have one saved
    card_fingerprint = Stripe::Token.retrieve(token).try(:card).try(:fingerprint)

    # Check whether a card with that fingerprint already exists
    default_card = customer.cards.all.data.select{|card| card.fingerprint == card_fingerprint}.last if card_fingerprint

    # Create new card if do not already exists
    default_card = customer.cards.create({:card => token}) unless default_card

    # Set the default card of the customer to be this card, as this is the last card provided by User and probably he want this card to be used for further transactions
    customer.default_card = default_card.id

    # Save the customer
    customer.save
  end
end