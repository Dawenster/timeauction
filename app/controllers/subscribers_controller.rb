class SubscribersController < ApplicationController
  def create
    respond_to do |format|
      existing_subscriber = Subscriber.find_by_email(params[:subscriber][:email])
      if existing_subscriber
        existing_subscriber.update_attributes(:user_id => params[:subscriber][:user_id]) if params[:subscriber][:user_id]
        format.json { render :json => {:message => "#{existing_subscriber.email} is already subscribed :)"} }
      else
        @subscriber = Subscriber.new(subscriber_params)
        if @subscriber.save
          format.json { render :json => {:message => "#{@subscriber.email} has been added successfully."} }
        else
          format.json { render :json => {:message => "Hm... something went wrong... please try again later!"} }
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
end