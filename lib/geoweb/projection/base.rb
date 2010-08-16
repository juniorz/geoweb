module GeoWeb
  module Projection

    class Base
      attr_accessor :zoom, :transformation

      def initialize(zoom, t=Transformation.new(1, 0, 0, 0, 1, 0))
        @zoom = zoom
        @transformation = t
      end

      def raw_project(point); nil; end
      def raw_unproject(point); nil; end

      def project(point)
        point = self.raw_project(point)
        point = transformation.transform(point) unless transformation.nil?
        point
      end

      def unproject(point)
        point = transformation.untransform(point) unless transformation.nil?
        point = self.raw_unproject(point)
        point
      end

      def location_coordinate(latlon)
        point = self.project(latlon.to_rad)
        Coordinate.new(point.x, point.y, self.zoom)
      end

      def coordinate_location(coordinate)
        coordinate = coordinate.zoom_to(self.zoom)
        point = Point.new(coordinate.x, coordinate.y)
        point = self.unproject(point)
        LatLon.new(point).to_deg
      end

    end

  end  
end
