
require "shortest_path"

class Maze

  def initialize(seed)
    @seed     = seed
    @walls    = Hash.new { |h, xy| h[xy] = calculate_wall(*xy) }
    @location = [1, 1]
  end

  def open_space?(x, y)
    (x >= 0) && (y >= 0) && !wall?(x, y)
  end

  def wall?(x, y)
    @walls[[x, y]]
  end

  def neighbours(x, y)
    [[1, 0], [0, 1], [0, -1], [-1, 0]]
      .map { |dx, dy| [x+dx, y+dy] }
      .select { |nx, ny| open_space?(nx, ny) }
  end

  private

  def calculate_wall(x, y)
    (x*x + 3*x + 2*x*y + y + y*y + @seed).to_s(2).count("1").odd?
  end

end

def render(maze, w, h, tx, ty)
  h.times do |y|
    line = w.times.map do |x|
      if maze.wall?(x, y)
        "#"
      else
        "."
      end
    end.join

    puts line
  end
end

def shortest_distance(maze, x, y, tx, ty)
  finder = ShortestPath::Finder.new([x, y], [tx, ty]).tap do |shortest_path|
    shortest_path.ways_finder = Proc.new { |x, y| maze.neighbours(x, y).each_with_object({}) { |(x, y), dist| dist[[x, y]] = 1 } }
  end
  finder.path.size - 1
end


# maze = Maze.new(10)
# render(maze, 10, 7, 7, 4)

# p shortest_distance(maze, 1, 1, 7, 4)


puts shortest_distance(maze, 1, 1, 7, 4)

maze = Maze.new(1358)
render(maze, 40, 45, 31, 39)

p shortest_distance(maze, 1, 1, 31, 39)
