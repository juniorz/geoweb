#require 'matrix'
#require 'mathn'
#require 'bigdecimal'
#TODO - Procurar Proj4js e Procurar Proj4R(uby)

module GeoWeb
  DEG_TO_RAD = Math::PI / 180.0

  autoload :Point,            'geoweb/point'
  autoload :Location,         'geoweb/location'
  autoload :LatLon,           'geoweb/lat_lon'
  autoload :Coordinate,       'geoweb/coordinate'
  autoload :Transformation,   'geoweb/transformation'
  autoload :Projection,       'geoweb/projection'
  autoload :Map,              'geoweb/map'

  class << self
    def deg_to_rad(location)
      location * [DEG_TO_RAD, DEG_TO_RAD, 1]
    end

    def rad_to_deg(location)
      location / [DEG_TO_RAD, DEG_TO_RAD, 1]
    end
  end
end
