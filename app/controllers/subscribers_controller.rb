class SubscribersController < ApplicationController
  def create
    respond_to do |format|
      email = params[:subscriber][:email].downcase
      existing_subscriber = Subscriber.find_by_email(email)
      if existing_subscriber
        existing_subscriber.update_attributes(:user_id => params[:subscriber][:user_id]) if params[:subscriber][:user_id]
        flash[:alert] = "#{existing_subscriber.email} is already subscribed :)"
        format.json { render :json => {:message => "#{existing_subscriber.email} is already subscribed :)"} }
      else
        @subscriber = Subscriber.new(subscriber_params)
        if legit_email?(email)
          if @subscriber.save
            @subscriber.add_to_mailchimp unless hk_domain? || Rails.env.test?
            flash[:notice] = "#{@subscriber.email} has been subscribed successfully."
            format.json { render :json => {:message => "#{@subscriber.email} has been subscribed successfully."} }
          else
            flash[:alert] = "Hm... something went wrong... please try again later!"
            format.json { render :json => {:message => "Hm... something went wrong... please try again later!"} }
          end
        else
          flash[:alert] = "Please enter a legitimate email!"
          format.json { render :json => {:message => "Please enter a legitimate email!"} }
        end
      end
    end
  end

  private 

  def subscriber_params
    params.require(:subscriber).permit(
      :email,
      :user_id
    )
  end

  def legit_email?(string)
    !!(string =~ /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/)
  end
end