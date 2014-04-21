class HoursEntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @hours_entries = HoursEntry.where(:user_id => current_user).order("created_at DESC")
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
    @hours_entry.user_entered = true
    if @hours_entry.save
      begin
        HoursEntryMailer.submitted(@hours_entry).deliver
      rescue
        binding.pry
      end
      flash[:notice] = "Your have saved #{@hours_entry.amount_in_words}"
      redirect_to hours_entries_path
    else
      flash.now[:alert] = @hours_entry.errors.full_messages.join(". ") + "."
      render "new"
    end
  end

  def destroy
    hours_entry = HoursEntry.find(params[:id])
    hours_entry.destroy
    flash[:notice] = "You have deleted #{hours_entry.amount_in_words}"
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
      :user_id,
      :dates
    )
  end
end