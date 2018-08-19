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
    @size = size
    @nodes = Hash.new { |h, k| h[k] = Hash.new(:clean) }
  end

  def weaken(x, y)
    @nodes[y][x] = :weakened
  end

  def infect(x, y)
    @nodes[y][x] = :infected
  end

  def flag(x, y)
    @nodes[y][x] = :flagged
  end

  def clean(x, y)
    @nodes[y][x] = :clean
  end

  def state(x, y)
    @nodes[y][x]
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
    case @grid.state(@x, @y)
    when :infected
      @grid.clean(@x, @y)
      turn(RIGHT)
    when :clean
      @grid.infect(@x, @y)
      turn(LEFT)
      @infections += 1
    else
      raise ArgumentError
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
        sprintf(format, dump_cell(x, y))
      end.join("")
    end.join("\n")
  end

  protected

  def dump_cell(x, y)
    @grid.state(x, y) == :infected ? "#" : "."
  end

  def turn(towards_direction)
    @direction = (@direction + towards_direction) % 4
  end

  def move_forward
    dx, dy = DIRECTIONS.fetch(@direction)
    @x += dx
    @y += dy
  end

end

class Virus2 < Virus

  AROUND = 2

  def burst
    case @grid.state(@x, @y)
    when :clean
      @grid.weaken(@x, @y)
      turn(LEFT)

    when :weakened
      @grid.infect(@x, @y)
      @infections += 1

    when :infected
      @grid.flag(@x, @y)
      turn(RIGHT)

    when :flagged
      @grid.clean(@x, @y)
      turn(AROUND)

    else
      raise ArgumentError

    end
    move_forward
  end

  protected

  CELLS = {
    clean: ".",
    weakened: "W",
    infected: "#",
    flagged: "F",
  }

  def dump_cell(x, y)
    CELLS.fetch(@grid.state(x, y))
  end

end


TEST = File.read("test.txt")
INPUT = File.read("input.txt")

# Test
test_virus = Virus.new(Grid.parse(TEST))
10_000.times do |n|
  test_virus.burst
end
puts "=====" * 10
puts test_virus.dump
p test_virus.infections

test_virus2 = Virus2.new(Grid.parse(TEST))
100.times do |n|
  #puts "-- #{n} --" * 10
  #puts test_virus2.dump
  test_virus2.burst
end
puts "=====" * 10
puts test_virus2.dump
p test_virus2.infections

# Part 1
puzzle_virus = Virus.new(Grid.parse(INPUT))
10_000.times { puzzle_virus.burst }
p puzzle_virus.infections

# Part 2
puzzle_virus2 = Virus2.new(Grid.parse(INPUT))
10_000_000.times { puzzle_virus2.burst }
p puzzle_virus2.infections
