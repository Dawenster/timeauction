class RegistrationsController < Devise::RegistrationsController
  def edit
    if current_user.stripe_cus_id
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      begin
        @cards = Stripe::Customer.retrieve(current_user.stripe_cus_id).sources.all(:object => "card").data
        @has_cards = @cards.any?
      rescue
        # If a similar Stripe object exists in live mode, but a test mode key was used to make this request.
        @cards = nil
        @has_cards = false
      end
    end
  end

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      render "edit"
    end
  end

  def destroy
    UserMailer.notify_admin_of_account_cancellation(resource).deliver
    resource.remove_from_mailchimp
    resource.destroy
    set_flash_message :notice, :destroyed
    redirect_to root_path
  end
end