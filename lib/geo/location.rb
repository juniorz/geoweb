# -*- coding: utf-8 -*-
module Geo
  class Location < Point
    alias lat y
    alias lat= y=
    alias lon x
    alias lon= x=

#    def lat; @y; end
#    def lat=(y); @y = y; end
#    def lon; @x; end
#    def lon=(x); @x = x; end

    def self.from_lat_lon(lat, lon)
      self.new(lon, lat)
    end

    def to_s
      "(#{sprintf('%f', lat)}, #{sprintf('%f', lon)})"
    end

  end
end
