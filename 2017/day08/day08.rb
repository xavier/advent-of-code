
class Instruction

  PATTERN_REG = "[a-z]+"
  PATTERN_IMM = "-?\\d+"
  PATTERN_OP = ["inc", "dec", "==", "!=", "<", ">", "<=", ">="].map { |op| Regexp.escape(op) }.join("|")
  PATTERN_INS = "(#{PATTERN_REG}) (#{PATTERN_OP}) (#{PATTERN_IMM})"

  REGEX_LINE = /^#{PATTERN_INS} if #{PATTERN_INS}/

  def self.parse(line)
    if line =~ REGEX_LINE
      new($1, $2, $3.to_i, new($4, $5, $6.to_i))
    else
      raise ArgumentError
    end
  end

  def initialize(left, op, right, cond = nil)
    @left = left
    @op = op
    @right = right
    @cond = cond
  end

  def execute(regs)
    if @cond.nil? || @cond.execute(regs)
      execute_self(regs)
    end
  end

  private

  def execute_self(regs)
    case @op
    when "inc" then regs.update(@left) { |val| val + @right }
    when "dec" then regs.update(@left) { |val| val - @right }
    when "=="  then regs.get(@left) == @right
    when "!="  then regs.get(@left) != @right
    when "<="  then regs.get(@left) <= @right
    when ">="  then regs.get(@left) >= @right
    when "<"   then regs.get(@left) < @right
    when ">"   then regs.get(@left) > @right
    else
      raise ArgumentError
    end
  end

end

class Program

  def self.parse(text)
    text.split("\n").map { |line| Instruction.parse(line) }
  end

end

class Registers

  def initialize
    @regs = Hash.new { |h, k| h[k] = 0 }
  end

  def get(name)
    @regs[name]
  end

  def set(name, value)
    @regs[name] = value
  end

  def update(name, &block)
    set(name, block.call(get(name)))
  end

  def max_value
    @regs.values.max
  end

end

class VM

  attr_reader :registers

  def initialize()
    @registers = Registers.new
  end

  def execute(instructions)
    instructions.each do |instruction|
      instruction.execute(@registers)
    end
    self
  end

end

TEST = Program.parse(File.read("test.txt"))
p TEST

vm = VM.new.execute(TEST)
puts vm.registers.max_value

INPUT = Program.parse(File.read("input.txt"))

vm = VM.new.execute(INPUT)
puts vm.registers.max_value
