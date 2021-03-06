class OrganizationsController < ApplicationController
  before_filter :check_admin, :except => [:show, :select, :assign_to_user]

  def index
    @organizations = Organization.all(order: 'name')
  end

  def show
    @organization = Organization.find_by_url(params[:organization_url]) || Organization.find(params[:id])
    @program = @organization.programs.last
    @auctions = @organization.all_approved_auctions
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
          organizations << view_context.link_to(organization.name, organization_name_path(org_url))
        end
      end
      
      destroy_profiles(current_user, params["organizations"])
      current_user.add_to_mailchimp unless hk_domain? || Rails.env.test?

      flash[:notice] = organizations.any? ? "You are now a part of #{organizations.uniq.to_sentence}.".html_safe : "You are no longer associated with any organizations."

      redirect_url = params["organizations"] ? params["organizations"].keys.last : nil
      format.json { render :json => { :redirect_url => redirect_url } }
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
      :page_message,
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