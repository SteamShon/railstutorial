class PlacesController < ApplicationController
  def index
    params[:search] = params[:search] ? params[:search] : "seoul"
    @lat_lng = Geocoder.coordinates(params[:search])
    @view_mode = params[:view_mode] ? params[:view_mode] : "tile"
    @places = Place.near(@lat_lng, 100).paginate(page: params[:page])
    if @places == nil
      @places = Place.foursquare_venues(@lat_lng[0], @lat_lng[1])
    end
    
    @json = @places.to_gmaps4rails do |place, marker|
      marker.infowindow render_to_string(:partial => "place2", :locals => {:place => place})
      marker.sidebar place.name
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
