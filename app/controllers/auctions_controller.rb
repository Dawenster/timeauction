class AuctionsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    
  end

  def show
    
  end

  def new
    @auction = Auction.new
  end

  def create
    
  end

  def edit
    @auction = Auction.find(params[:id])
  end

  def update
    
  end

  def destroy
    
  end
end