# -*- coding: utf-8 -*-
module GeoWeb
  class Location < Point
    alias lat y
    alias lat= y=
    alias lon x
    alias lon= x=

    #If the object respond only to lat and lon, the second parameter can be z
    #Location.new(lat, lon)
    #Location.new(obj) - obj.lat and obj.lon
    #Location.new(obj) - obj.y and obj.x
    #TODO - Location.new(hash) - hash[:lat] and hash[:lon]
    def initialize(lon_or_object, lat=nil)
      lon = lon_or_object
      if lon.respond_to? :lat and lon.respond_to? :lon
        lon, lat = lon_or_object.lon, lon_or_object.lat
        z = lon_or_object.respond_to?(:z) && lon_or_object.z || lat
      end

      super(lon, lat)
    end

    def to_rad
      Location.to_rad(self)
    end

    def to_deg
      Location.to_deg(self)
    end

    def self.to_rad(location)
      location * [GeoWeb::DEG_TO_RAD, GeoWeb::DEG_TO_RAD, 1]
    end

    def self.to_deg(location)
      location / [GeoWeb::DEG_TO_RAD, GeoWeb::DEG_TO_RAD, 1]
    end

    def self.from_lat_lon(lat, lon)
      self.new(lon, lat)
    end

    def to_s
      "(#{sprintf('%f', lat)}, #{sprintf('%f', lon)})"
    end

  end
end
