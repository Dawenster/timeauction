class AuctionsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @auctions = Auction.order("created_at DESC")
  end

  def show
    @auction = Auction.find(params[:id])
  end

  def user_auctions
    @auctions = Auction.where(:user_id => current_user.id).order("created_at DESC")
  end

  def new
    @auction = Auction.new
    @auction.rewards.build
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
    @auction.rewards.build
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
      :short_description,
      :description,
      :about,
      :limitations,
      :target,
      :start,
      :end,
      :user_id,
      :banner,
      :image,
      :_destroy,
      rewards_attributes: [
        :id,
        :title,
        :description,
        :amount,
        :max,
        :auction_id,
        :limit_bidders,
        :_destroy
      ]
    )
  end
end