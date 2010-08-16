# -*- coding: utf-8 -*-
module GeoWeb
  class Transformation
    attr_reader :ax, :bx, :cx, :ay, :by, :cy

    def initialize(ax, bx, cx, ay, by, cy)
      @ax, @bx, @cx, @ay, @by, @cy = ax, bx, cx, ay, by, cy
    end

    # Transforms a point
    def transform(point)
      return Point.new(self.ax * point.x + self.bx * point.y + self.cx,
                   self.ay * point.x + self.by * point.y + self.cy)
    end

    # Inverse of transform
		def untransform(point)
		  Point.new((point.x*by - point.y*bx - cx*by + cy*bx) / (ax*by - ay*bx),
		            (point.x*ay - point.y*ax - cx*ay + cy*ax) / (bx*ay - by*ax))
		end

    def to_s
      "T([#{ax},#{bx},#{cx}][#{ay},#{by},#{cy}])"
    end

    # Generates a transform based on three pairs of points, a1 -> a2, b1 -> b2, c1 -> c2.
    def self.deriveTransformation(a1x, a1y, a2x, a2y, b1x, b1y, b2x, b2y, c1x, c1y, c2x, c2y)
      ax, bx, cx = linearSolution(a1x, a1y, a2x, b1x, b1y, b2x, c1x, c1y, c2x)
      ay, by, cy = linearSolution(a1x, a1y, a2y, b1x, b1y, b2y, c1x, c1y, c2y)

      self.new(ax, bx, cx, ay, by, cy)
    end

    # Solves a system of linear equations.
    #
    #  t1 = (a * r1) + (b + s1) + c
    #  t2 = (a * r2) + (b + s2) + c
    #  t3 = (a * r3) + (b + s3) + c
    #
    # r1 - t3 are the known values.
    # a, b, c are the unknowns to be solved.
    # returns the a, b, c coefficients.
    def self.linearSolution(r1, s1, t1, r2, s2, t2, r3, s3, t3)
      # make them all floats
      r1, s1, t1, r2, s2, t2, r3, s3, t3 = [r1, s1, t1, r2, s2, t2, r3, s3, t3].map{|n| n.to_f}

      a = (((t2 - t3) * (s1 - s2)) - ((t1 - t2) * (s2 - s3))) \
        / (((r2 - r3) * (s1 - s2)) - ((r1 - r2) * (s2 - s3)))

      b = (((t2 - t3) * (r1 - r2)) - ((t1 - t2) * (r2 - r3))) \
        / (((s2 - s3) * (r1 - r2)) - ((s1 - s2) * (r2 - r3)))

      c = t1 - (r1 * a) - (s1 * b)
      
      return a, b, c
    end

  end
end
