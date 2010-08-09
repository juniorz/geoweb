module Geo
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

      def location_coordinate(location)
        point = Point.new(Math::PI * location.lon.to_f / 180.0, Math::PI * location.lat.to_f / 180.0)
        point = self.project(point)

        Coordinate.new(point.y, point.x, self.zoom)
      end

      def coordinate_location(coordinate)
        coordinate = coordinate.zoom_to(self.zoom)
        point = Point.new(coordinate.column, coordinate.row)
        point = self.unproject(point)

        Location.from_lat_lon(180.0 * point.y.to_f / Math::PI, 180.0 * point.x.to_f / Math::PI)
      end

    end

  end  
end
