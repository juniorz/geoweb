module Geo
  module Projection

    class Linear < Base
      def raw_project(point)
        point.clone
      end

      def raw_unproject(point)
        point.clone
      end
    end

  end
end
