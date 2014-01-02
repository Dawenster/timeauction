class AuctionsController < ApplicationController
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