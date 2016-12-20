class Blacklist

  def self.parse(data)
    new(
      data
        .split("\n")
        .map { |line| Range.new(*line.split("-").map(&:to_i)) }
    )
  end

  attr_reader :ranges

  def initialize(ranges)
    @ranges = sanitize(ranges)
  end

  def blocked_range_for(n)
    @ranges.detect { |range| range.include?(n) }
  end

  private

  def sanitize(ranges)
    consolidate(ranges).sort_by(&:first)
  end

  def consolidate(ranges)
    range, other = find_overlapping(ranges)
    if range
      new_range = merge(range, other)
      ranges.delete(range)
      ranges.delete(other)
      ranges << new_range
      consolidate(ranges)
    else
      ranges
    end
  end

  def find_overlapping(ranges)
    for range in ranges
      other = ranges.detect { |other| (other != range) && overlaps?(range, other) }
      return [range, other] if other
    end
    nil
  end

  def overlaps?(range, other)
    range.cover?(other.first) || other.cover?(range.first)
  end

  def merge(range, other)
    lower_bound  = [range.first, other.first].min
    higher_bound = [range.last, other.last].max
    lower_bound..higher_bound
  end

end

def find_first_valid_ip(blacklist)
  ip = 0
  while ip <= 0xffff_ffff
    range = blacklist.blocked_range_for(ip)
    if range
      ip = range.last + 1
    else
      return ip
    end
  end
end

def count_valid_ips(blacklist, total = 0x1_0000_0000)
  blacklist.ranges.reduce(total) do |valid_count, range|
    valid_count - range.size
  end
end

# Test case
# blacklist = Blacklist.new([5..8, 0..2, 4..7])
# puts find_first_valid_ip(blacklist)
# puts count_valid_ips(blacklist, 10)

# Puzzle
blacklist = Blacklist.parse(File.read("input.txt"))
# Part 1
puts find_first_valid_ip(blacklist)
# Part 2
puts count_valid_ips(blacklist)
