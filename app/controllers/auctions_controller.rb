class AuctionsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :check_creator, :only => [:edit, :update, :destroy]

  def index
    @auctions = Auction.where(:submitted => true).order("created_at DESC")
  end

  def show
    @auction = Auction.find(params[:id])
  end

  def user_auctions
    @participated_auctions = current_user.rewards.order("created_at DESC").map{ |reward| reward.auction }.uniq
    @saved_auctions = Auction.where(:submitted => false).where(:user_id => current_user.id).order("created_at DESC")
    @submitted_auctions = Auction.not_approved.where(:submitted => true).where(:user_id => current_user.id).order("created_at DESC")
    @approved_auctions = Auction.where(:approved => true).where(:user_id => current_user.id).order("created_at DESC")
  end

  def new
    @auction = Auction.new
    @auction.rewards.build
  end

  def create
    @auction = Auction.new(auction_params)
    @auction.user_id = current_user.id
    if params[:save]
      if @auction.save
        flash[:notice] = "#{@auction.title} has been successfully created."
        redirect_to auction_path(@auction)
      else
        flash[:alert] = "Please make sure all fields are filled in correctly :)"
        render "new"
      end
    else
      if @auction.save(:validate => false)
        flash[:notice] = "Your auction has been successfully saved."
        redirect_to user_auctions_path(current_user.username)
      else
        flash[:alert] = "Please make sure all fields are filled in correctly :)"
        render "new"
      end
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
      :volunteer_end_date,
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

  def check_creator
    auction = Auction.find(params[:id])
    if auction.user != current_user
      flash[:alert] = "You are not authorized to edit this auction."
      redirect_to auction_path(auction) || root_path
    end
  end
end