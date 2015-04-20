class HoursEntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @hours_entries = HoursEntry.where(:user_id => current_user).order("created_at DESC")
  end

  def show
    @hours_entry = HoursEntry.find(params[:id])
    if @hours_entry.user != current_user
      flash[:alert] = "Sorry! You were not authorized to view that page."
      redirect_to request.referrer || root_path
    end
  end

  def new
    @hours_entry = HoursEntry.new
  end

  def create
    respond_to do |format|
      @hours_entry = HoursEntry.new(hours_entry_params)
      @hours_entry.user_id = current_user.id
      @hours_entry.user_entered = true

      if @hours_entry.save
        format.json { render :json => { :hours_entry_id => @hours_entry.id, :fail => false } }
        format.html do
          flash[:notice] = "You have successfully logged #{@hours_entry.amount_in_words}"
          notify_admin_of_created_hours_entry
          redirect_to user_path(current_user)
        end
      else
        format.json { render :json => { :message => @hours_entry.errors.full_messages.join(". ") + "." }, :fail => true }
        format.html do
          flash.now[:alert] = @hours_entry.errors.full_messages.join(". ") + "."
          render "new"
        end
      end
    end
  end

  def destroy
    hours_entry = HoursEntry.find(params[:id])
    hours_entry.destroy
    flash[:notice] = "You have deleted #{hours_entry.amount_in_words}"
    redirect_to user_path(current_user)
  end

  def admin_send_verification_email
    hours_entry = HoursEntry.find(params[:hours_entry_id])
    begin
      hours_entry.send_verification_email
    rescue
      flash[:alert] = "Holy crap something went wrong!"
    end
    redirect_to admin_hours_entries_path
  end

  private

  def hours_entry_params
    params.require(:hours_entry).permit(
      :amount,
      :organization,
      :contact_name,
      :contact_phone,
      :contact_email,
      :contact_position,
      :description,
      :user_id,
      :dates
    )
  end

  def notify_admin_of_created_hours_entry
    begin
      HoursEntryMailer.submitted(@hours_entry, hk_domain?).deliver
    rescue
      raise "error"
    end
  end
end