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
      errors = false

      raw_details = params["hours_entry"]["dates"].split(", ")

      params["hours_entry"]["dates"].split(", ").each do |date|
        split_details = date.split("-")
        hours = split_details[0]
        month = split_details[1]
        year = split_details[2]

        @hours_entry = HoursEntry.new(hours_entry_params)
        @hours_entry.amount = hours
        @hours_entry.month = month
        @hours_entry.year = year
        @hours_entry.user_id = current_user.id
        @hours_entry.user_entered = true

        if !@hours_entry.save
          errors = true
          break
        end
      end

      if errors
        errors = @hours_entry.errors.full_messages
        format.json { render :json => { :message => errors.join(". ") + "." }, :fail => true }
        format.html do
          flash.now[:alert] = errors.join(". ") + "."
          render "new"
        end
      else
        format.json { render :json => { :hours_entry_id => @hours_entry.id, :fail => false } }
        format.html do
          flash[:notice] = "You have successfully logged some hours"
          notify_admin_of_created_hours_entry
          redirect_to user_path(current_user)
        end
      end
    end
  end

  def log_hours
    @hours_entries = current_user.hours_entries.logged.order("created_at DESC")
  end

  def update
    hours_entry = HoursEntry.find(params[:id])
    hours_entry.assign_attributes(hours_entry_params)
    if hours_entry.save
      flash[:notice] = "You have successfully updated your verifier"
    else
      flash[:alert] = hours_entry.errors.full_messages.join(". ") + "."
    end
    redirect_to log_hours_path
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
      hours_entry.send_verification_email(hk_domain?, current_user.id)
    rescue
      flash[:alert] = "Holy crap something went wrong!"
    end
    redirect_to request.referrer || admin_hours_entries_path
  end

  def admin_send_verified_email
    hours_entry = HoursEntry.find(params[:hours_entry_id])
    begin
      hours_entry.send_verified_emails
    rescue
      flash[:alert] = "Holy crap something went wrong!"
    end
    redirect_to request.referrer || admin_hours_entries_path
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
      :dates,
      :program_name
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