
class Knot

  def self.bindigest(key)
    new(256).tie(key.bytes + [17, 31, 73, 47, 23], 64).dense_hash.pack("c*").unpack("B*").first
  end

  def initialize(size)
    @points = Array(0...size)
    @position = 0
    @skip_size = 0
  end

  def tie(lengths, rounds = 1)
    rounds.times do
      lengths.each do |length|
        reverse(length)
        skip(length)
      end
    end
    self
  end

  def check
    @points.take(2).reduce(:*)
  end

  def knot_hash
    dense_hash.pack("c*").unpack("H*").first
  end

  def dense_hash(block_size = 16)
    @points
      .each_slice(@points.size / block_size)
      .map { |slice| slice.reduce(&:^) }
  end

  private

  def reverse(length)
    lo, hi = @position, @position + length - 1
    while lo < hi
      a, b = get(lo), get(hi)
      set(lo, b)
      set(hi, a)
      lo += 1
      hi -= 1
    end
  end

  def skip(length)
    @position = wrap(@position + length + @skip_size)
    @skip_size += 1
  end

  def get(position)
    @points.fetch(wrap(position))
  end

  def set(position, value)
    @points[wrap(position)] = value
  end

  def wrap(pos)
    pos % @points.size
  end

  def to_s
    @points.each_with_index.map { |v, i| i == @position ? "(#{v})" : v }.join(" ")
  end

end

class Regions

  def initialize(matrix)
    @matrix = matrix
    @size = matrix.size
    @size_range = 0...@size
  end

  def discover
    x = y = count = 0
    loop do
      x, y = find_used(x, y)
      if x
        count += 1
        fill(x, y, count)
      else
        return count
      end
    end
  end

  def to_s
    @matrix.map(&:join).join("\n")
  end

  private

  def find_used(x, y)
    max = @size - 1
    while !used?(x, y)
      if x < max
        x += 1
      else
        x = 0
        if y < max
          y += 1
        else
          return nil
        end
      end
    end
    return [x, y]
  end

  NEIGHBORS = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0]
  ]

  def fill(x, y, tag)
    queue = [[x, y]]
    while coords = queue.shift do
      x, y = coords
      set(x, y, tag)
      NEIGHBORS.each do |dx, dy|
        nx = x + dx
        ny = y + dy
        queue << [nx, ny] if used?(nx, ny)
      end
    end
  end

  def used?(x, y)
    get(x, y) == "#"
  end

  def get(x, y)
    in?(x) && in?(y) ? @matrix[y][x] : nil
  end

  def set(x, y, value)
    @matrix[y][x] = value
  end

  def in?(x)
     @size_range.include?(x)
  end

end

INPUT = "wenycdww"

# Part 1
disk = 128.times.map { |idx| Knot.bindigest("#{INPUT}-#{idx}").tr("01", ".#") }.join("\n")
# puts disk
puts disk.count("#")

# Part 2
regions = Regions.new(disk.split("\n").map { |line| line.split("") })
count = regions.discover
puts count
