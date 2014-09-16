class CompaniesController < ApplicationController
  def index
    @companies = Company.all(order: 'name')
  end

  def show
    @company = Company.find_by_url(params[:company_url]) || Company.find(params[:id])
  end

  def new
    @company = Company.new
    @company.email_domains.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      flash[:notice] = "#{@company.name} has been successfully created."
      redirect_to company_path(@company)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "new"
    end
  end

  def edit
    @company = Company.find(params[:id])
    @company.email_domains.build
  end

  def update
    @company = Company.find(params[:id])
    cp = remove_blank_email_domains
    @company.assign_attributes(cp)
    if @company.save
      flash[:notice] = "#{@company.name} has been successfully updated."
      redirect_to company_path(@company)
    else
      flash.now[:alert] = "Please make sure all fields are filled in correctly :)"
      render "edit"
    end
  end

  def destroy
    company = Company.find(params[:id]).destroy
    flash[:notice] = "#{company.name} has been deleted."
    redirect_to root_path
  end

  private 

  def company_params
    params.require(:company).permit(
      :name,
      :url,
      :logo,
      :background_image,
      :_destroy,
      email_domains_attributes: [
        :id,
        :domain,
        :company_id,
        :created_at,
        :updated_at,
        :_destroy
      ]
    )
  end

  def remove_blank_email_domains
    cp = company_params
    company_params["email_domains_attributes"].each do |k, v|
      if v["domain"].blank?
        cp["email_domains_attributes"] = cp["email_domains_attributes"].except(k)
      end
    end
    return cp
  end
end