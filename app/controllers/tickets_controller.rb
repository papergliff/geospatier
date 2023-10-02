class TicketsController < ApplicationController
  def index
    @tickets = DigsiteFetcher.all
  end

  def show
    if @digsite_info = DigsiteFetcher.polygon_points(params[:id])
      render :show
    else
      flash[:alert] = "Ticket not found"
      redirect_to tickets_path
    end
  end
end
