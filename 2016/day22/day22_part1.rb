

class Node

  attr_reader :x, :y, :size, :used

  def initialize(x, y, size, used)
    @x, @y = x, y
    @size  = size
    @used  = used
  end

  def coords
    [@x, @y]
  end

  def viable?(other)
    !empty? && !same?(other) && other.fits?(used)
  end

  def empty?
    @used.zero?
  end

  def same?(other)
    (@x == other.x) && (@y == other.y)
  end

  def fits?(size)
    (@used + size) < @size
  end

end


class Grid

  attr_reader :nodes

  def initialize
    @nodes = {}
    @maxx = 0
    @maxy = 0
  end

  def add(node)
    @nodes[node.coords] = node
    @maxx = [@maxx, node.x].max
    @maxy = [@maxy, node.y].max
    self
  end

  def viable_nodes
    viable = []
    @nodes.values.each do |a|
      @nodes.values.each do |b|
        viable << [a, b] if a.viable?(b)
      end
    end
    viable.uniq
  end

end

def parse(data)
  # Filesystem              Size  Used  Avail  Use%
  # /dev/grid/node-x0-y0     92T   70T    22T   76%
  data
    .scan(/\/dev\/grid\/node\-x(\d+)\-y(\d+)\s+(\d+)T\s+(\d+)T/)
    .reduce(Grid.new) do |grid, (x, y, size, used)|
      grid.add(Node.new(x.to_i, y.to_i, size.to_i, used.to_i))
    end
end

grid = parse(File.read("input.txt"))

puts grid.viable_nodes.size
