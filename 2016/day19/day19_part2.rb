
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

  def run!
    idx = 0
    while @elves.size > 1 do
      half_circle = (@elves.size.to_f / 2).floor
      giver_idx = (idx + half_circle) % @elves.size
      #@elves[idx].presents += @elves[giver_idx].presents
      #puts "Elf #{@elves[idx].number} takes from Elf #{@elves[giver_idx].number} and now has #{@elves[idx].presents}"
      @elves.delete_at(giver_idx)
      puts @elves.size if (idx % 1000).zero?
      idx = (idx + 1) % @elves.size
    end
  end

  def to_s
    @elves.join(", ")
  end

end

# table = Table.new(5)
# puts table
# table.run!
# puts table

table = Table.new(3_014_387)
table.run!
puts table

# 31728 too low :'(
# 155665 too low
