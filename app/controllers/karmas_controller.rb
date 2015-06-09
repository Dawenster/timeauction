class KarmasController < ApplicationController
  autocomplete :nonprofit, :name, :full => true

  before_filter :authenticate_user!

  def add
    @donation = Donation.new
  end

  def create
    respond_to do |format|
      errors = false

      binding.pry

      params["user"]["hours_entries"].each do |entry|
        raw_details = entry["dates"].split(", ")

        raw_details.each do |date|
          @hours_entry = instantiate_hours_entry(date)

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
          flash[:notice] = "You have successfully logged some hours"
          notify_admin_of_created_hours_entry
          redirect_to user_path(current_user)
        end
      end
    end
  end

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

  def instantiate_hours_entry(date)
    entry = HoursEntry.new
    split_details = date.split("-")
    hours = split_details[0]
    month = split_details[1]
    year = split_details[2]

    entry.amount = hours
    entry.month = month
    entry.year = year
    entry.user_id = current_user.id
    entry.user_entered = true

    return entry
  end
end