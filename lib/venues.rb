module Venues
  require 'net/http'
  require 'uri'
  def self.foursquare_venues(lat, lng, query)
    api_key = "YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    api_call = "http://api.infochimps.com/geo/location/foursquare/places/search?"
    api_call += "g.radius=10000&g.latitude=#{lat}&g.longitude=#{lng}&f.q=#{query}&"
    api_call += "apikey=YoonYung-uArHmiat7aAGZIdqMjkEOjwY569"
    uri = URI.parse(api_call)
    response = Net::HTTP.get_response(uri)
    JSON(response.body)
  end
end
