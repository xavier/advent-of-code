
class CPU

  attr_reader :pc
  attr_reader :steps

  def initialize(jump_offsets)
    @jump_offsets = jump_offsets
    @pc = 0
    @steps = 0
  end

  def run(debug: false)
    loop do
      puts(to_s) if debug
      offset = @jump_offsets.fetch(@pc)
      @jump_offsets[@pc] += 1
      @pc += offset
      @steps += 1
    end
  rescue IndexError
    nil
  end

  def to_s
    @jump_offsets
      .each_with_index
      .map { |off, idx| idx == @pc ? "(#{off})" : off }
      .join(" ")
  end

end

INPUT = File.read("input.txt").split("\n").map(&:to_i)

cpu = CPU.new([0, 3, 0, 1, -3])
cpu.run(debug: true)
puts cpu.steps

cpu = CPU.new(INPUT)
cpu.run
puts cpu.steps
