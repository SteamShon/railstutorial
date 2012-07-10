class PlacesController < ApplicationController
  def index
    @places = Place.paginate(page: params[:page])
  end 

  def new
    @place = Place.new
  end
  
  def create
    @place = Place.new(params[:place])
    if @place.save
      flash[:notice] = "new place is registered. now add your diary on this place"
      redirect_to current_user
    else
      render 'new'
    end
  end
end
