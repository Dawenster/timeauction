class OrganizationsController < ApplicationController
  before_filter :check_admin, :except => [:show]

  def index
    @organizations = Organization.all(order: 'name')
  end

  def show
    @organization = Organization.find_by_url(params[:organization_url]) || Organization.find(params[:id])
    @program = @organization.programs.last
    @auctions = @organization.current_auctions
  end

  def new
    @organization = Organization.new
    @organization.email_domains.build
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      flash[:notice] = "#{@organization.name} has been successfully created."
      redirect_to organization_path(@organization)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "new"
    end
  end

  def edit
    @organization = Organization.find(params[:id])
    @organization.email_domains.build
  end

  def update
    @organization = Organization.find(params[:id])
    cp = remove_blank_email_domains
    @organization.assign_attributes(cp)
    if @organization.save
      flash[:notice] = "#{@organization.name} has been successfully updated."
      redirect_to organization_path(@organization)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "edit"
    end
  end

  def destroy
    organization = Organization.find(params[:id]).destroy
    flash[:notice] = "#{organization.name} has been deleted."
    redirect_to root_path
  end

  private 

  def organization_params
    params.require(:organization).permit(
      :name,
      :url,
      :logo,
      :background_image,
      :_destroy,
      email_domains_attributes: [
        :id,
        :domain,
        :organization_id,
        :created_at,
        :updated_at,
        :_destroy
      ]
    )
  end

  def remove_blank_email_domains
    cp = organization_params
    organization_params["email_domains_attributes"].each do |k, v|
      if v["domain"].blank?
        cp["email_domains_attributes"] = cp["email_domains_attributes"].except(k)
      end
    end
    return cp
  end

  def check_admin
    unless current_user && current_user.admin
      redirect_to root_path
    end
  end
end