
class Spinlock

  def initialize(steps)
    @steps = steps
    @position = 0
    @buffer = [0]
  end

  def spin
    @position = ((@position + @steps) % rounds).succ
    @buffer.insert(@position, rounds)
    self
  end

  def rounds
    @buffer.size
  end

  def position(val)
    @buffer.index(val)
  end

  def value_at(pos)
    @buffer[pos]
  end

  def at?(pos)
    @position == pos
  end

  def to_s
    @buffer
      .each_with_index
      .map { |val, idx| at?(idx) ? "(#{val})" : val.to_s }
      .join(" ")
  end

end

class FastSpinlock

  attr_reader :after_zero

  def initialize(steps)
    @steps = steps
    @position = 0
    @rounds = 0
    @after_zero = 0
  end

  def spin
    @rounds += 1
    @position = ((@position + @steps) % @rounds).succ
    @after_zero = @rounds if @position == 1
  end

end

# Test case
test = Spinlock.new(3)
10.times { puts test.spin }

# Puzzle
INPUT = 348

# Part 1
part1 = Spinlock.new(INPUT)
2017.times { part1.spin }
puts part1.value_at(part1.position(2017).succ)

# Part 2
part2 = FastSpinlock.new(INPUT)
50_000_000.times { |i| part2.spin }
puts part2.after_zero
