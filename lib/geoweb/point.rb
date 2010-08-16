# -*- coding: utf-8 -*-
module GeoWeb
  class Point
    attr_accessor :x, :y, :z

    # ClassMethods
    class << self
      def from_hash(coord)
        self.new(coord[:x], coord[:y], coord[:z])
      end

      def from_array(coord)
        self.new(coord[0], coord[1], coord[2])
      end
    end

    #If the object respond only to x and y, the second parameter can be z
    #Point.new(x, y)
    #Point.new(obj) - obj.x and obj.y and obj.z
    #Point.new(obj, z) - obj.x and obj.y
    #TODO - Point.new(hash) - hash[:x] and hash[:y] and hash[:z]
    #TODO - Point.new(hash, z) - hash[:x] and hash[:y]
    def initialize(x_or_object, y=nil, z=nil)
      x = x_or_object
      if x_or_object.respond_to? :x and x_or_object.respond_to? :y
        x, y = x_or_object.x, x_or_object.y
        z = x_or_object.respond_to?(:z) && x_or_object.z || y
      end
      @x, @y, @z = x, y, z
    end

    def round!
      @x = @x.round
      @y = @y.round
      @z = @z && @z.round
      self
    end

    def round
      self.clone.round!
    end

    # Spatial sum (sums x, y and z)
    def +(other)
      self.class.new(self.x + other.x, self.y + other.y, self.z.to_i + other.z.to_i)
    end

    # Planar sum (sums x and y)
    def |(other)
#      new_z = self.z unless self.z != other.z
      self.class.new(self.x + other.x, self.y + other.y, self.z)
    end

    def -(other)
      self.class.new(self.x - other.x, self.y - other.y, self.z.to_i - other.z.to_i)
    end

    def ==(other)
      self.class.x == other.x and self.y == other.y and self.z.to_i == other.z.to_i
    end

    # Point multiplication. Accepts other point, a Numeric or an Array
    def *(other)
      if other.respond_to? :x and other.respond_to? :y and other.respond_to? :z
        self.class.new(self.x.to_f * other.x.to_f, self.y.to_f * other.y.to_f, self.z.to_f * other.z.to_f)
      elsif other.respond_to? :to_a
        self * self.class.from_array(other.to_a)
      else
        self.class.new(self.x.to_f * other.to_f, self.y.to_f * other.to_f, self.z.to_f * other.to_f)
      end
    end

    # Point division. Accepts other point, a Numeric or an Array
    def /(other)
#      self.class.new(self.x / num, self.y / num, self.z)
      if other.respond_to? :x and other.respond_to? :y and other.respond_to? :z
        self.class.new(self.x.to_f / other.x.to_f, self.y.to_f / other.y.to_f, self.z.to_f / other.z.to_f)
      elsif other.respond_to? :to_a
        self / self.class.from_array(other.to_a)
      else
        self.class.new(self.x.to_f / other.to_f, self.y.to_f / other.to_f, self.z.to_f / other.to_f)
      end
    end

    def to_s
      "(#{sprintf('%f', @x)}, #{sprintf('%f', @y)}, #{@z})"
    end

    def to_a
      [@x, @y, @z]
    end

    def to_hash
      {:x => @x, :y => @y, :z => @z}
    end

  end
end
