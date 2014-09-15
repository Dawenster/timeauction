class CompaniesController < ApplicationController
  def show
    @company = Company.find_by_url(params[:company_url])
  end

  def new
    
  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end

  private 

  def company_params
    params.require(:company).permit(
      :name,
      :url,
      :logo,
      :background_image,
      email_domains_attributes: [
        :domain,
        :company_id
      ]
    )
  end
end