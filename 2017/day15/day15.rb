
class Generator

  def initialize(initial_value, factor)
    @value = initial_value
    @factor = factor
  end

  def next
    @value = (@value * @factor) % 2147483647
  end

end

class Judge

  def initialize(gen_a, gen_b)
    @gen_a = gen_a
    @gen_b = gen_b
  end

  def pick(rounds)
    Enumerator.new do |enum|
      rounds.times do
        a, b = @gen_a.next, @gen_b.next
        enum.yield(a, b) if match?(a, b)
      end
    end
  end

  def match?(a, b)
    (a & 0xffff) == (b & 0xffff)
  end

end



test_a = Generator.new(65, 16807)
test_b = Generator.new(8921, 48271)

# p 5.times.map { [test_a.next, test_b.next] }
# p Judge.new(test_a, test_b).take(1)

puzzle_a = Generator.new(277, 16807)
puzzle_b = Generator.new(349, 48271)

judge = Judge.new(puzzle_a, puzzle_b)
p judge.pick(40_000_000).count
