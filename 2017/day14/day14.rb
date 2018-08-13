
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

INPUT = "wenycdww"

# Part 1
disk = 128.times.map { |idx| Knot.bindigest("#{INPUT}-#{idx}") }.join("\n")
puts disk.count("1")

# Part 2
