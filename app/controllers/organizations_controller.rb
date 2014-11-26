class OrganizationsController < ApplicationController
  before_filter :check_admin, :except => [:show, :select]

  def index
    @organizations = Organization.all(order: 'name')
  end

  def show
    @organization = Organization.find_by_url(params[:organization_url]) || Organization.find(params[:id])
    @program = @organization.programs.last
    @auctions = @organization.current_and_pending_auctions
  end

  def new
    @organization = Organization.new
    @organization.email_domains.build
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      flash[:notice] = "#{@organization.name} has been successfully created."
      redirect_to organization_name_path(@organization.url)
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
    @organization.assign_attributes(organization_params)
    if @organization.save
      flash[:notice] = "#{@organization.name} has been successfully updated."
      redirect_to organization_name_path(@organization.url)
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

  def select
    respond_to do |format|
      format.json { render :json => { :organizations => Organization.organizations_to_select(current_user) } }
    end
  end

  def assign_to_user
    respond_to do |format|
      organizations = []

      if params["organizations"]
        params["organizations"].each do |org_url, fields|
          organization = Organization.find_by_url(org_url)
          Profile.create_or_update_for(org_url, fields, organization.id, current_user)
          organizations << organization.name
        end
      end
      
      destroy_profiles(current_user, params["organizations"])

      flash[:notice] = "You are now a part of #{organizations.uniq.to_sentence}."
      format.json { render :json => { :message => "Success!" } }
    end
  end

  private 

  def organization_params
    params.require(:organization).permit(
      :name,
      :url,
      :logo,
      :background_image,
      :people_descriptor,
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

  def check_admin
    unless current_user && current_user.admin
      redirect_to root_path
    end
  end

  def destroy_profiles(user, orgs)
    if orgs
      user.profiles.each do |profile|
        org_url = profile.organization.url
        profile.destroy unless orgs[org_url]
      end
    else
      user.profiles.destroy_all
    end
  end
end