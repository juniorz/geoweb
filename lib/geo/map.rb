module Geo

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
      @origin_pixel = options[:origin_pixel] || Point.new(0, 0, 1)

#      @transformation = options[:transformation] || default_transformation
      @projection = options[:projection] || default_mercator_projection(options[:transformation])
    end

    def width; @width ||= map_extent(zoom, tile_width); end
    def height; @height ||= map_extent(zoom, tile_height); end

=begin
    def tile_to_point(tile)
      Point.new(@tile_width * (tile.column - @origin_tile.column),
                @tile_height * (tile.row - @origin_tile.row),
                tile.z)
    end
=end

    def relative_point(point)
      (@origin_pixel + point)
    end

    # Return an x, y point on the map image for a given geographical location.
    def location_point(location)
      coord = projection.location_coordinate(location).zoom_to(zoom)
      point = Point.new(@tile_width * (coord.column - @origin_tile.column),
                        @tile_height * (coord.row - @origin_tile.row),
                        0) # Point.+ sums the zoom too

      # because of the center/corner business
#      point.x += self.dimensions.x/2
#      point.y += self.dimensions.y/2

      relative_point(point).round!
    end

    # Return a geographical location on the map image for a given x, y point.
    def point_location(point)

=begin
        # distance in tile widths from reference tile to point
        tiles_distance = Coordinate.new((point.x - @origin_tile.x) / tile_width,
                                        (point.y - @origin_tile.y) / tile_height,
                                        0)

        # distance in rows & columns at maximum zoom
        distance = tiles_distance * 2 ** (Coordinate::MAX_ZOOM - zoom)

        # Relative Tile at maximum zoom
        # Down to current zoom
        coord = (hizoom_origin_tile + distance).zoom_to(zoom)
=end
        # distance in tile widths from origin tile to point
        # can not be rounded
        tiles_distance = Coordinate.new((point.x - @origin_tile.x) / tile_width,
                                        (point.y - @origin_tile.y) / tile_height,
                                        zoom) #Sets the distance zoom, only to use zoom_to()

        # distance in rows & columns at maximum zoom
        distance = tiles_distance.zoom_to(Coordinate::MAX_ZOOM)
        distance.z = 0                     #Unsets, distance have no zoom

        # origin tile at maximum zoom
        hizoom_origin_tile = @origin_tile.zoom_to(Coordinate::MAX_ZOOM)

        # relative tile at maximum zoom, resized down to current zoom
        # can not be rounded
        coord = (hizoom_origin_tile + distance).zoom_to(zoom)

        # relative tile location
        location = projection.coordinate_location(coord)
    end


=begin
    def locationPoint(self, location):
        """ Return an x, y point on the map image for a given geographical location.
        """
        point = Core.Point(self.offset.x, self.offset.y)
        coord = self.provider.locationCoordinate(location).zoomTo(self.coordinate.zoom)
        
        # distance from the known coordinate offset
        point.x += self.provider.tileWidth() * (coord.column - self.coordinate.column)
        point.y += self.provider.tileHeight() * (coord.row - self.coordinate.row)
        
        # because of the center/corner business
        point.x += self.dimensions.x/2
        point.y += self.dimensions.y/2
        
        return point
        
    def pointLocation(self, point):
        """ Return a geographical location on the map image for a given x, y point.
        """
        hizoomCoord = self.coordinate.zoomTo(Core.Coordinate.MAX_ZOOM)
        
        # because of the center/corner business
        point = Core.Point(point.x - self.dimensions.x/2,
                           point.y - self.dimensions.y/2)
        
        # distance in tile widths from reference tile to point
        xTiles = (point.x - self.offset.x) / self.provider.tileWidth();
        yTiles = (point.y - self.offset.y) / self.provider.tileHeight();
        
        # distance in rows & columns at maximum zoom
        xDistance = xTiles * math.pow(2, (Core.Coordinate.MAX_ZOOM - self.coordinate.zoom));
        yDistance = yTiles * math.pow(2, (Core.Coordinate.MAX_ZOOM - self.coordinate.zoom));
        
        # new point coordinate reflecting that distance
        coord = Core.Coordinate(round(hizoomCoord.row + yDistance),
                                round(hizoomCoord.column + xDistance),
                                hizoomCoord.zoom)

        coord = coord.zoomTo(self.coordinate.zoom)
        
        location = self.provider.coordinateLocation(coord)
        
        return location
=end


    private
    def default_mercator_projection(transformation)
      transformation ||= default_transformation
      Geo::Projection::Mercator.new(26, transformation)
    end

    def default_transformation
      # see: http://modestmaps.mapstraction.com/trac/wiki/TileCoordinateComparisons#TileGeolocations
      Geo::Transformation.new(1.068070779e7, 0, 3.355443185e7, 0, -1.068070890e7, 3.355443057e7)
    end

  end

end
