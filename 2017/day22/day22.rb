require "set"

class Grid

  def self.parse(text)
    lines = text.strip.split("\n")
    new(lines.size).tap do |grid|
      lines.each_with_index do |line, y|
        line
          .split("")
          .each_with_index do |char, x|
            grid.infect(x, y) if char == "#"
          end
      end
    end
  end

  attr_reader :size

  def initialize(size)
    @size  = size
    @nodes = Hash.new { |h, k| h[k] = Set.new }
  end

  def infected?(x, y)
    @nodes[y].include?(x)
  end

  def infect(x, y)
    @nodes[y].add(x)
  end

  def clean(x, y)
    @nodes[y].delete(x)
  end

end

class Virus

  RIGHT = 1
  LEFT = -1

  DIRECTIONS = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0]
  ]

  attr_reader :infections

  def initialize(grid)
    @grid = grid
    @x = @y = grid.size / 2
    @direction = 0
    @infections = 0
  end

  def burst
    if @grid.infected?(@x, @y)
      @grid.clean(@x, @y)
      turn(RIGHT)
    else
      @grid.infect(@x, @y)
      turn(LEFT)

      @infections += 1
    end
    move_forward
    self
  end

  FORMAT_CURRENT = "[%s]"
  FORMAT_OTHER = " %s "

  def dump(size = 4)
    (-size..size).map do |y|
      (-size..size).map do |x|
        format = (@x == x && @y == y) ? FORMAT_CURRENT : FORMAT_OTHER
        sprintf(format, @grid.infected?(x, y) ? "#" : ".")
      end.join("")
    end.join("\n")
  end

  private

  def turn(towards_direction)
    @direction = (@direction + towards_direction) % 4
  end

  def move_forward
    dx, dy = DIRECTIONS.fetch(@direction)
    @x += dx
    @y += dy
  end

end


TEST = File.read("test.txt")
INPUT = File.read("input.txt")

# Test
test_virus = Virus.new(Grid.parse(TEST))
10_000.times do |n|
  #puts "-- #{n} --" * 10
  #puts test_virus.dump
  test_virus.burst
end
puts "=====" * 10
puts test_virus.dump
p test_virus.infections

# Part 1
puzzle_virus = Virus.new(Grid.parse(INPUT))
10_000.times { puzzle_virus.burst }
p puzzle_virus.infections
