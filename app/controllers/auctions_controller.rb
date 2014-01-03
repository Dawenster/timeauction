class AuctionsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @auctions = Auction.order("created_at DESC")
  end

  def show
  end

  def new
    @auction = Auction.new
    @auction.tiers.build
  end

  def create
    @auction = Auction.new(auction_params)
    @auction.user_id = current_user.id
    if @auction.save
      flash[:notice] = "#{@auction.title} has been successfully created."
      redirect_to auctions_path
    else
      flash[:alert] = "Please make sure all fields are filled in correctly :)"
      render "new"
    end
  end

  def edit
    @auction = Auction.find(params[:id])
  end

  def update
    @auction = Auction.find(params[:id])
    @auction.assign_attributes(auction_params)
    if @auction.save
      flash[:notice] = "#{@auction.title} has been successfully updated."
      redirect_to auctions_path
    else
      flash[:alert] = "Please make sure all fields are filled in correctly :)"
      render "edit"
    end
  end

  def destroy
    auction = Auction.find(params[:id]).destroy
    flash[:notice] = "#{auction.title} has been deleted."
    redirect_to auctions_path    
  end

  private 

  def auction_params
    params.require(:auction).permit(
      :title,
      :approved,
      :description,
      :target,
      :start,
      :end,
      :user_id,
      tiers_attributes: [
        :title,
        :description,
        :amount,
        :max,
        :auction_id,
        :limit_bidders
      ]
    )
  end
end