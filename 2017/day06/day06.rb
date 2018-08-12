require "set"

class Memory

  def initialize(banks)
    @banks = banks
  end

  def count_cycles_until_same
    states = Set.new()
    until states.include?(@banks)
      states.add(@banks)
      cycle!
    end
    states.count
  end

  def cycle!
    blocks, start_index = @banks.each_with_index.max_by { |blocks, idx| blocks }
    redistribute(blocks, start_index)
  end

  def redistribute(blocks, idx)
    @banks[idx] = 0
    blocks.times do
      idx = idx.succ % @banks.count
      @banks[idx] += 1
    end
  end

  def to_s
    @banks.inspect
  end

end

INPUT = File.read("input.txt").split().map(&:to_i)

# Test case
test = Memory.new([0, 2, 7, 0])
puts test.count_cycles_until_same

# Puzzle
memory = Memory.new(INPUT.dup)
puts memory.count_cycles_until_same # part 1
puts memory.count_cycles_until_same # part 2
