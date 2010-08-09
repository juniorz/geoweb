# -*- coding: utf-8 -*-
module Geo
  class Point
    attr_accessor :x, :y, :z

    def initialize(x, y, z=nil)
      @x, @y, @z = x, y, z
    end

    def self.from_hash(coord)
      self.new(coord[:x], coord[:y], coord[:z])
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

    def +(other)
      self.class.new(self.x + other.x, self.y + other.y, self.z.to_i + other.z.to_i)
    end

    def -(other)
      self.class.new(self.x - other.x, self.y - other.y, self.z.to_i - other.z.to_i)
    end

    def ==(other)
      self.class.x == other.x and self.y == other.y and self.z.to_i == other.z.to_i
    end

    def *(num)
      self.class.new(self.x * num, self.y * num, self.z) 
    end

    def /(num)
      self.class.new(self.x / num, self.y / num, self.z) 
    end

    def to_s
      "#{@x}, #{@y}, #{@z}"
    end

    def to_a
      [@x, @y, @z]
    end

    def to_hash
      {:x => @x, :y => @y, :z => @z}
    end

  end
end
