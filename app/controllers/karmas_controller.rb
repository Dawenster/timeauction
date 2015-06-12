class KarmasController < ApplicationController
  autocomplete :nonprofit, :name, :full => true

  before_filter :authenticate_user!

  def add
    @donation = Donation.new
  end

  def create
    respond_to do |format|
      errors = false

      params[:user][:hours_entries_attributes].values.each do |entry|
        raw_details = entry["dates"].split(", ")
        raw_details.each do |date|
          @hours_entry = instantiate_hours_entry(date, entry)
          if !@hours_entry.save
            errors = true
            break
          end
        end
      end

      if errors
        errors = @hours_entry.errors.full_messages
        format.json { render :json => { :message => errors.join(". ") + "." }, :fail => true }
        format.html do
          flash.now[:alert] = errors.join(". ") + "."
          render "add"
        end
      else
        format.json { render :json => { :hours_entry_id => @hours_entry.id, :fail => false } }
        format.html do
          flash[:notice] = "You have successfully added some Karma Points"
          notify_admin_of_created_hours_entry
          redirect_to user_path(current_user)
        end
      end
    end
  end

  def instantiate_hours_entry(date, entry)
    entry.delete("_destroy")
    hours_entry = HoursEntry.new(entry)
    split_details = date.split("-")
    hours = split_details[0]
    month = split_details[1]
    year = split_details[2]

    hours_entry.amount = hours
    hours_entry.month = month
    hours_entry.year = year
    hours_entry.user_id = current_user.id
    hours_entry.user_entered = true

    return hours_entry
  end

  def notify_admin_of_created_hours_entry
    begin
      HoursEntryMailer.submitted(@hours_entry, hk_domain?).deliver
    rescue
      raise "error"
    end
  end
end