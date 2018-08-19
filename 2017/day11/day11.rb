
class Vector

  attr_reader :x, :y, :z

  def initialize(x = 0, y = 0, z = 0)
    @x = x
    @y = y
    @z = z
  end

  def +(other)
    Vector.new(x + other.x, y + other.y, z + other.z)
  end

  def distance(other)
    ((self.x - other.x).abs + (self.y - other.y).abs + (self.z - other.z).abs) / 2
  end

end

class Hexgrid

  DIRECTION = {
    "n" => Vector.new(0, 1, -1),
    "ne" => Vector.new(1, 0, -1),
    "se" => Vector.new(1, -1, 0),
    "s" => Vector.new(0, -1, 1),
    "sw" => Vector.new(-1, 0, 1),
    "nw" => Vector.new(-1, 1, 0)
  }

  attr_reader :grid

  def initialize
  end

  def walk(path)
    origin = Vector.new(0, 0, 0)

    path.reduce([origin, nil, 0]) do |(position, _, furthest), dir|
      new_position = position + DIRECTION.fetch(dir)
      current_distance = origin.distance(new_position)
      [new_position, current_distance, [furthest, current_distance].max]
    end
  end

end

# Test
[
  "ne,ne,ne",
  "ne,ne,sw,sw",
  "ne,ne,s,s",
  "se,sw,se,sw,sw"
].each do |path|
  p Hexgrid.new.walk(path.split(","))
end

# Part 1

INPUT = File.read("input.txt").strip.split(",")
p Hexgrid.new.walk(INPUT)
