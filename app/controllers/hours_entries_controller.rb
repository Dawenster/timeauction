class HoursEntriesController < ApplicationController
  def index
    @hours_entries = HoursEntry.order("created_at DESC")
  end

  def show
    @hours_entry = HoursEntry.find(params[:id])
  end

  def new
    @hours_entry = HoursEntry.new
  end

  def create
    @hours_entry = HoursEntry.new(hours_entry_params)
    @hours_entry.user_id = current_user.id
    if @hours_entry.save
      flash[:notice] = "Your hours are saved."
      redirect_to hours_entries_path
    else
      flash[:alert] = @hours_entry.error_messages.join(". ")
      render "new"
    end
  end

  def edit
    @hours_entry = HoursEntry.find(params[:id])
  end

  def update
    @hours_entry = HoursEntry.find(params[:id])
    @hours_entry.attributes = hours_entry_params
    @hours_entry.user_id ||= current_user.id
    if @hours_entry.save
      flash[:notice] = "Your hours are saved."
      redirect_to hours_entries_path
    else
      flash[:alert] = @hours_entry.error_messages.join(". ")
      render "new"
    end
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
      :user_id
    )
  end
end