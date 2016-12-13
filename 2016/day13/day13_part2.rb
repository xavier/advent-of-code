require "set"

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

def render(maze, w, h, visited)
  h.times do |y|
    line = w.times.map do |x|
      if maze.wall?(x, y)
        "###"
      else
        if d = visited[[x, y]]
          " %02d" % [d]
        else
          "..."
        end
      end
    end.join

    puts line
  end
end

def visitable_locations(maze, x, y, step, steps, visited = {}, depth = 0)
  return visited if step > steps || !maze.open_space?(x, y)

  visited[[x, y]] = step

  maze
    .neighbours(x, y)
    .reject { |xy| (s = visited[xy]) && (s < step) }
    .each do |nx, ny|
      found = visitable_locations(maze, nx, ny, step + 1, steps, visited, depth + 1)
      visited.merge!(found)
    end

  visited
end

maze = Maze.new(1358)

visited = visitable_locations(maze, 1, 1, 0, 50)

puts visited.size
