class ProgramsController < ApplicationController
  before_filter :check_admin

  def index
    @programs = Program.all(order: 'name')
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      flash[:notice] = "#{@program.name} has been successfully created."
      redirect_to organization_name_path(@program.organization.url)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "new"
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])
    @program.assign_attributes(program_params)
    if @program.save
      flash[:notice] = "#{@program.name} has been successfully updated."
      redirect_to organization_name_path(@program.organization.url)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "edit"
    end
  end

  def destroy
    program = Program.find(params[:id]).destroy
    flash[:notice] = "#{program.name} has been deleted."
    redirect_to root_path
  end

  private 

  def program_params
    params.require(:program).permit(
      :name,
      :description,
      :eligible_period,
      :organization_id,
      :_destroy
    )
  end

  def check_admin
    unless current_user && current_user.admin
      redirect_to root_path
    end
  end
end