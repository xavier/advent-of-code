
class CPU

  attr_reader :pc
  attr_reader :steps

  def initialize(jump_offsets)
    @jump_offsets = jump_offsets.dup
    @pc = 0
    @steps = 0
  end

  def run(debug: false)
    loop do
      puts(to_s) if debug
      offset = @jump_offsets.fetch(@pc)
      @jump_offsets[@pc] += act_strange(offset)
      act_strange(offset)
      @pc += offset
      @steps += 1
    end
  rescue IndexError
    nil
  end

  def act_strange(offset)
    1
  end

  def to_s
    @jump_offsets
      .each_with_index
      .map { |off, idx| idx == @pc ? "(#{off})" : off }
      .join(" ")
  end

end

class CPU2 < CPU

  def act_strange(offset)
    offset < 3 ? 1 : -1
  end

end


INPUT = File.read("input.txt").split("\n").map(&:to_i)

# Part 1

cpu = CPU.new([0, 3, 0, 1, -3])
cpu.run(debug: true)
puts cpu.steps

cpu = CPU.new(INPUT)
cpu.run
puts cpu.steps

# Part 2

cpu = CPU2.new([0, 3, 0, 1, -3])
cpu.run()
puts cpu.steps

cpu = CPU2.new(INPUT)
cpu.run
puts cpu.steps
