module Geo
  module Projection

    class Mercator < Base

      def raw_project(point)
        Point.new(point.x,
                  Math::log(Math::tan(0.25 * Math::PI + 0.5 * point.y)))
      end

      def raw_unproject(point)
        Point.new(point.x,
                  2 * Math::atan(Math::E ** point.y) - 0.5 * Math::PI)
      end
    end

  end
end
