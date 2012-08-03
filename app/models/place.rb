class Place < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :name, :created_at, :updated_at
  has_many :reviews
  has_many :users, :through => :reviews
  validates :latitude, presence: true
  validates :longitude, presence: true
  
  require 'net/http'
  require 'uri'
  require 'will_paginate/array'
  geocoded_by :address
  before_validation :geocode, :if => :address_changed?
  reverse_geocoded_by :latitude, :longitude
  before_validation :reverse_geocode
  acts_as_gmappable

  def gmaps
    true
  end

  def self.foursquare_venues(lat, lng, query="")
    api_key = "YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    api_call = "http://api.infochimps.com/geo/location/foursquare/places/search?"
    api_call += "g.radius=10000&g.latitude=#{lat}&g.longitude=#{lng}&f.q=#{query}&"
    api_call += "apikey=YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    uri = URI.parse(URI.escape(api_call))
    response = Net::HTTP.get_response(uri)
    json = JSON(response.body)
    puts json
    ret = {}
    json["results"].each do |r|
      cur_name = r["name"].downcase
      cur_id = "foursquare_#{r["_domain_id"]}"
      if Place.where("name = ?", r["name"].downcase).size == 0
        ret[cur_name] = Place.create({ name: r["name"].downcase, 
        latitude: r["coordinates"][1], longitude: r["coordinates"][0] })
      else
        ret[cur_name] = Place.where("name = ?", r["name"].downcase).first
      end
    end
    return ret.values
  end
  
  def gmaps4rails_address
    @address
  end

  def review_photo(photo_type="thumb")
    reviews = self.reviews
    return reviews.size == 0 ? "http://placehold.it/100x100" : reviews[-1].photo.url(photo_type)
  end

  def self.all_updates
    Place.all.sort{|a, b| b.reviews[-1].updated_at <=> a.reviews[-1].updated_at}
  end

  def last_review
    if self.reviews.any?
      return self.reviews[-1]
    else
      return nil
    end
  end
end
