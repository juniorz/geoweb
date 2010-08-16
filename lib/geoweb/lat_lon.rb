# -*- coding: utf-8 -*-
module GeoWeb
  class LatLon
    attr_accessor :lat, :lon
    alias y lat
    alias y= lat=
    alias x lon
    alias x= lon=

    #If the object respond only to lat and lon, the second parameter can be z
    #Location.new(lat, lon)
    #Location.new(obj) - obj.lat and obj.lon
    #Location.new(obj) - obj.y and obj.x
    #Location.new(hash) - hash[:lat] and hash[:lon]
    #Location.new(array) - hash[:lat] and hash[:lon]
    def initialize(lat_or_object, lon=nil)

      lat = lat_or_object
      if lon.nil?
        object = lat_or_object
        lat, lon = if latlongeable?(object)
          [object.lat, object.lon]
        elsif object.respond_to?(:y) and object.respond_to?(:x)
          [object.y, object.x]
        elsif object.respond_to?(:to_a)
          object.to_a.values_at 0, 1
        elsif object.respond_to?(:to_hash)
          object.to_hash.values_at :lat, :lon
        end
      end

      @lat, @lon = lat, lon
    end

    def +(other)
      other = self.class.new(other) unless latlongeable?(other)
      self.class.new(@lat + other.lat, @lon + other.lon)
    end

    def -(other)
      other = self.class.new(other) unless latlongeable?(other)
      self.class.new(@lat - other.lat, @lon - other.lon)
    end

    def ==(other)
      other = self.class.new(other) unless latlongeable?(other)
      @lat == other.lat and @lon == other.lon
    end

    # LatLon multiplication. Accepts other LatLon, a Numeric
    def *(other)
      if other.kind_of? Numeric
        self.class.new(@lat.to_f * other.to_f, @lon.to_f * other.to_f)
      else
        other = self.class.new(other) unless latlongeable?(other)
        self.class.new(@lat.to_f * other.lat.to_f, @lon.to_f * other.lon.to_f)
      end
    end

    # LatLon division. Accepts other LatLon, a Numeric or an Array
    def /(other)
      if other.kind_of? Numeric
        self.class.new(@lat.to_f./(other.to_f), @lon.to_f./(other.to_f))
      else
        other = self.class.new(other) unless latlongeable?(other)
        self.class.new(@lat.to_f./(other.lat.to_f), @lon.to_f./(other.lon.to_f))
      end
    end

    def round!
      @lat = @lat.round
      @lon = @lon.round
      self
    end

    def round
      self.clone.round!
    end

    def abs!
      @lat = @lat.abs
      @lon = @lon.abs
      self
    end

    def abs
      self.clone.abs!
    end

    def to_rad
      self.class.to_rad(self)
    end

    def to_deg
      self.class.to_deg(self)
    end

    def self.to_rad(latlon)
      latlon * [GeoWeb::DEG_TO_RAD, GeoWeb::DEG_TO_RAD]
    end

    def self.to_deg(latlon)
      latlon / [GeoWeb::DEG_TO_RAD, GeoWeb::DEG_TO_RAD]
    end

    def to_a
      [@lat, @lon]
    end

    def to_hash
      {:lat => @lat, :lon => @lon}
    end

    def to_s
      "(#{sprintf('%f', lat)}, #{sprintf('%f', lon)})"
    end

    private
    def latlongeable?(other)
      other.respond_to?(:lat) and other.respond_to?(:lon)
    end

  end
end
