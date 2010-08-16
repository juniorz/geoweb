module GeoWeb

  class Map
    attr_accessor :projection, :zoom #, :transformation
    attr_accessor :boundaries
    attr_accessor :tile_width, :tile_height

    # Calculates the map-size (width or height) given a tile size and specific zoom
    def self.map_extent(zoom, tile_size=256)
      2 ** (zoom + Math::log(tile_size)/Math::log(2))
    end

    def initialize(options={})
      @tile_width = options[:tile_width] || 256
      @tile_height = options[:tile_height] || 256
      @zoom = options[:zoom] || 1
      @boundaries = options[:boundaries] || {}

      @origin_tile = options[:origin_tile] || Coordinate.new(0, 0, @zoom)
      @origin_pixel = options[:origin_pixel] || Point.new(0, 0, @zoom)
#      @dimensions = Point.new(map_extent(@zoom, @tile_width), map_extent(@zoom, @tile_height))

#      @transformation = options[:transformation] || default_transformation
      @projection = options[:projection] || default_mercator_projection(options[:transformation])
    end

    #SAME AS DIMENSIONS, retirar isso
    def width; @width ||= GeoWeb::Map.map_extent(zoom, tile_width); end
    def height; @height ||= GeoWeb::Map.map_extent(zoom, tile_height); end

    def relative_point(point)
      (point - @origin_pixel)
    end
    
    def absolute_point(offset)
      (@origin_pixel + offset)
    end

    # Return an x, y point on the map image for a given geographical location.
    def location_point(location)
      coord = projection.location_coordinate(location).zoom_to(zoom)
      point = (coord - @origin_tile) * [@tile_width, @tile_height]
      return absolute_point(point)
    end

    # Faster, but is accurate only to zoom levels lesser than 17
    def coordinates_to_point(location)
      lat, lon = location.lat, location.lon

      #Parece que ele faz isso pra representar como uma fração (sem sinal) de 2Pi
      #http://en.wikipedia.org/wiki/Longitude#Noting_and_calculating_longitude
      long_deg = (-180.0 - lon).abs
      long_ppd = width.to_f / 360.0
      long_ppdrad = width.to_f / (2.0 * Math::PI)
      px_x = long_deg * long_ppd

      e = Math::sin( lat * (1.0/180.0 * Math::PI) )
      e = 0.9999 if e > 0.9999
      e = -0.9999 if e < -0.9999
      px_y = (height / 2.0) + 0.5 * Math::log((1+e)/(1-e)) * (-long_ppdrad)

      return absolute_point(Point.new(px_x, px_y, zoom))
    end

    # Return a geographical location on the map image for a given x, y point.
    def point_location(point)
        # origin tile at maximum zoom
        hizoom_origin_tile = @origin_tile.zoom_to(Coordinate::MAX_ZOOM)

        # distance in tile widths from reference tile to point
        tiles_distance = relative_point(point) / [@tile_width, @tile_height]

        # distance in rows & columns at maximum zoom
        distance = Coordinate.new(tiles_distance.x, tiles_distance.y, zoom).zoom_to(Coordinate::MAX_ZOOM)
        distance.z = 0

        # absolute tile at maximum zoom
        tile = (hizoom_origin_tile + distance).round!
        tile = tile.zoom_to(zoom)

        location = projection.coordinate_location(tile)
        return location
    end

    private
    def default_mercator_projection(transformation)
      transformation ||= default_transformation
      GeoWeb::Projection::Mercator.new(26, transformation)
    end

    def default_transformation
      # see: http://modestmaps.mapstraction.com/trac/wiki/TileCoordinateComparisons#TileGeolocations
      GeoWeb::Transformation.new(1.068070779e7, 0.0, 3.355443185e7, 0.0, -1.068070890e7, 3.355443057e7)
    end

  end

end
