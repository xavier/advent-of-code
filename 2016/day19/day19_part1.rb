
class Elf

  attr_reader   :number
  attr_accessor :presents

  def initialize(number)
    @number   = number
    @presents = 1
  end

  def to_s
    "Elf #{number} has #{presents} presents"
  end

end

class Table

  attr_reader :elves

  def initialize(size)
    @elves = size.times.map { |n| Elf.new(n + 1) }
  end

  def step!
    idx = 0
    while idx < @elves.size do
      next_idx = (idx + 1) % @elves.size
      @elves[idx].presents += @elves[next_idx].presents
      @elves[next_idx].presents = 0
      idx += 2
    end
    @elves = @elves.reject { |elf| elf.presents.zero? }
  end

  def to_s
    @elves.map { |elf| elf }.join(", ")
  end

end

# table = Table.new(5)
# puts table
# table.step!
# puts table
# table.step!
# puts table

table = Table.new(3_014_387)

while table.elves.size > 1 do
  puts table.elves.size
  table.step!
end

puts table
