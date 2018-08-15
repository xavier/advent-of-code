require "pp"

class Env

  attr_accessor :pc

  def initialize()
    @regs = Hash.new { |h, k| h[k] = 0 }
    @stack = []
    @pc = 0
  end

  def get(x)
    @regs[x]
  end

  def set(x, val = nil, &block)
    if block_given?
     @regs[x] = yield @regs[x]
    else
      @regs[x] = val
    end
  end

  def push(val)
    @stack.push(val)
  end

  def pop()
    @stack.pop()
  end

  def dump
    "pc: #{@pc}\nregs: #{@regs.inspect}\nstack: #{@stack.inspect}"
  end

end

class Imm

  def initialize(value)
    @value = value
  end

  def set(_env, _val, &block)
    raise NotImplementedError
  end

  def get(_env)
    @value
  end

  def to_s
    "<Imm #{@value}>"
  end

end

class Reg

  def initialize(name)
    @name = name
  end

  def set(env, val = nil, &block)
    env.set(@name, val, &block)
  end

  def get(env)
    env.get(@name)
  end

  def to_s
    "<Reg #{@name}>"
  end

end

class Instruction

  attr_reader :op

  def self.parse(line)
    mnemonic, *operands = line.split(/\s+/)
    new(mnemonic, *Array(operands).map { |val| val =~ /-?\d+/ ? Imm.new(val.to_i) : Reg.new(val) })
  end

  def initialize(op, x, y = nil)
    @op = op
    @x = x
    @y = y
  end

  def execute(env)
    case @op
    when "snd"
      env.push(@x.get(env))

    when "set"
      @x.set(env, @y.get(env))

    when "add"
      @x.set(env) { |x| x + @y.get(env) }

    when "mul"
      @x.set(env) { |x| x * @y.get(env) }

    when "mod"
      @x.set(env) { |x| x % @y.get(env) }

    when "rcv"
      unless @x.get(env).zero?
        throw env.pop()
      end

    when "jgz"
      env.pc += @y.get(env) if @x.get(env) > 0

    else
      raise ArgumentError
    end
  end

  def to_s
    "#{op} #{@x} #{@y}".strip
  end

end

class Machine

  def initialize()
  end

  def execute(instructions)
    @env = Env.new
    while 0 <= @env.pc && @env.pc < instructions.size  do
      puts "---"
      puts @env.dump
      puts instructions[@env.pc]
      old_pc = @env.pc
      instructions.fetch(@env.pc).execute(@env)
      @env.pc += 1 if @env.pc == old_pc
    end

  end

end

def parse(code)
  code
    .split("\n")
    .map { |line| Instruction.parse(line) }

end

# Test

# TEST = File.read("test.txt")

# test_instructions = parse(TEST)

# test = Machine.new()
# test.execute(test_instructions)

# Part 1

INPUT = File.read("input.txt")

puzzle_instructions = parse(INPUT)

puzzle = Machine.new()
puzzle.execute(puzzle_instructions)
