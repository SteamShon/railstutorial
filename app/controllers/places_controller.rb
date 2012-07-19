class PlacesController < ApplicationController
  def index
    @lat_lng = [37.5692, 127.0035]
    if params[:search]
      @places = Place.foursquare_venues(@lat_lng[0], @lat_lng[1],
        params[:search]).paginate(page: params[:search_page], per_page: 10)
    else
      @places = Place.paginate(page: params[:page])
    end
    @json = @places.to_gmaps4rails do |place, marker|
      marker.infowindow render_to_string(:partial => "place", :locals => {:place => place})
      marker.sidebar place.name
      #marker.sidebar render_to_string(:partial => "place", :locals => {:place => place})
    end
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
