# -*- coding: utf-8 -*-
module GeoWeb
  class Coordinate < Point
    MAX_ZOOM = 25

    alias row y
    alias row= y=

    alias column x
    alias column= x=

    def zoom_to(destination)
      self.class.new(self.x * 2 ** (destination - self.z),
                     self.y * 2 ** (destination - self.z),
                     destination)
    end

    def zoom_by(distance)
      self.class.new(self.x * 2 ** distance,
                     self.y * 2 ** distance,
                     self.z + distance)
    end

#    def to_s
#      "(#{sprintf('%f', @x)}, #{sprintf('%f', @y)}, #{@z})"
#    end

  end
end
