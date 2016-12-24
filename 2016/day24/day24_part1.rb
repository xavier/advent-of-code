require "set"
require "shortest_path"

class Maze

  attr_reader :nodes, :locations, :start

  def initialize()
    @nodes = Set.new
    @start = nil
    @locations = Set.new
  end

  def parse(data)
    data
      .split("\n")
      .each_with_index do |row, y|
        row.chars.each_with_index do |cell, x|
          case cell
          when "."
            @nodes << [x, y]
          when "0"
            @nodes << [x, y]
            @start = [x, y]
          when /\d/
            @nodes << [x, y]
            @locations << [x, y]
          end
        end
      end
    self
  end

  def neighbours(x, y)
    [[1, 0], [0, 1], [0, -1], [-1, 0]]
      .map { |dx, dy| [x+dx, y+dy] }
      .select { |nx, ny| open_space?(nx, ny) }
  end

  def open_space?(x, y)
    @nodes.include?([x, y])
  end

  def shortest_path(from_x, from_y, to_x, to_y)
    ShortestPath::Finder.new([from_x, from_y], [to_x, to_y]).tap do |shortest_path|
      shortest_path.ways_finder = Proc.new { |x, y| edges(x, y) }
    end.path
  end

  private

  def edges(x, y)
    neighbours(x, y)
      .each_with_object({}) do |(x, y), dist|
        dist[[x, y]] = 1
      end
  end

end


def crawl(maze, x, y, locations, steps = 0)
  return steps if locations.empty?

  locations.map do |loc|
    loc_x, loc_y = loc
    path = maze.shortest_path(x, y, loc_x, loc_y)
    crawl(maze, loc_x, loc_y, locations.dup.delete(loc), steps + path.size - 1)
  end.min

end

example = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"""

#maze = Maze.new.parse(example.strip)

# puts crawl(maze, maze.start[0], maze.start[1], maze.locations)

maze = Maze.new.parse(File.read("input.txt"))
puts crawl(maze,  maze.start[0], maze.start[1], maze.locations)
