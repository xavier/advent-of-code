
class Diagram

  attr_reader :path
  attr_reader :steps

  def self.parse(text)
    start_line, *others = text.split("\n")
    start = start_line.index("|")
    cells = others.map do |line|
      line.split("").map do |char|
        char == " " ? nil : char
      end
    end
    new(start, cells)
  end

  def initialize(start, cells)
    @x = start
    @y = 0
    @dx = 0
    @dy = 1
    @cells = cells
    @steps = 1
  end

  def walk
    @path = []

    while walk_step
      # gets
      @steps += 1
    end
  end

  def walk_step
    cell = cell_at(@x, @y)

    # puts "(#{@x}, #{@y}) = #{cell}"

    case cell

    when "|", "-"
      proceed

    when /[A-Z]/
      @path << cell
      proceed

    when "+"
      turn
      proceed

    else
      return false

    end

    return true

  end

  private

  def cell_at(x, y)
    @cells[y][x]
  end

  def proceed
    @x += @dx
    @y += @dy
  end

  DIRECTIONS = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0]
  ]

  def turn
    @dx, @dy = DIRECTIONS.detect do |dx, dy|
      (dx != @dx) && (dy != @dy) && cell_at(@x + dx, @y + dy) =~/[\-\|A-Z]/
    end
  end

end

# Test
test_diagram = Diagram.parse(File.read("test.txt"))
test_diagram.walk
puts test_diagram.path.join
puts test_diagram.steps

# Puzzle
puzzle_diagram = Diagram.parse(File.read("input.txt"))
puzzle_diagram.walk

# Part 1
puts puzzle_diagram.path.join

# Part 2
puts puzzle_diagram.steps
