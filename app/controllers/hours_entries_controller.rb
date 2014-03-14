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
      HoursEntryMailer.submitted(@hours_entry).deliver
      flash[:notice] = "Your hours are saved."
      redirect_to hours_entries_path
    else
      flash[:alert] = @hours_entry.errors.full_messages.join(". ")
      render "new"
    end
  end

  def destroy
    hours_entry = HoursEntry.find(params[:id])
    hours_entry.destroy
    redirect_to hours_entries_path
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