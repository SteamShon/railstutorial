class Place < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :name
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

  def self.foursquare_venues(lat, lng, query="")
    api_key = "YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    api_call = "http://api.infochimps.com/geo/location/foursquare/places/search?"
    api_call += "g.radius=10000&g.latitude=#{lat}&g.longitude=#{lng}&f.q=#{query}&"
    api_call += "apikey=YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    uri = URI.parse(URI.escape(api_call))
    response = Net::HTTP.get_response(uri)
    json = JSON(response.body)
    ret = {}
    json["results"].each do |r|
      cur_name = r["name"].downcase
      if Place.where("name = ?", r["name"].downcase).size == 0
        ret[cur_name] = Place.create({ name: r["name"].downcase, latitude: r["coordinates"][1], longitude: r["coordinates"][0] })
      else
        ret[cur_name] = Place.where("name = ?", r["name"].downcase).first
      end
    end
    return ret.values
  end
end
