
require 'pp'

class State

  class Transition

    attr_reader :new_value, :direction, :next_state

    def initialize(new_value, direction, next_state)
      @new_value = new_value
      @direction = direction
      @next_state = next_state
    end

  end

  attr_reader :name

  DEFINITION_REGEX = /In state ([A-Z]+):\n\s+If the current value is 0:\n\s+- Write the value ([01]).\n\s+- Move one slot to the (right|left).\n\s+- Continue with state ([A-Z]+).\n\s+If the current value is 1:\n\s+- Write the value ([01]).\n\s+- Move one slot to the (right|left).\n\s+- Continue with state ([A-Z]+)./m

  def self.parse(definition)
    raise ArgumentError unless definition =~ DEFINITION_REGEX

    name = $1
    transitions = [
      Transition.new($2.to_i, $3.to_sym, $4),
      Transition.new($5.to_i, $6.to_sym, $7)
    ]

    new(name, transitions)
  end

  def initialize(name, transitions)
    @name = name
    @transitions = transitions
  end

  def transition(current_value)
    @transitions.fetch(current_value)
  end

end

class Tape

  def initialize()
    @cursor = 0
    @slots = [0]
  end

  def read
    @slots.fetch(@cursor)
  end

  def write(new_value)
    @slots[@cursor] = new_value
  end

  def move(direction)
    case direction
    when :left
      if @cursor > 0
        @cursor -= 1
      else
        @slots.unshift(0)
      end
    when :right
      if @cursor == (@slots.size - 1)
        @slots.push(0)
      end
      @cursor += 1
    else
      raise ArgumentError
    end
  end

  def checksum
    @slots.reduce(:+)
  end

  def to_s
    @slots.each_with_index.map do |value, index|
      index == @cursor ? "[#{value}]" : " #{value} "
    end.join
  end

end

class Machine

  HEADER_REGEX = /Begin in state ([A-Z]+).\nPerform a diagnostic checksum after (\d+) steps./m

  def self.parse(text)
    header, *state_definitions = text.split("\n\n")
    raise ArgumentError unless header =~ HEADER_REGEX

    start = $1
    steps = $2.to_i
    states = state_definitions.map do |state_definition|
      State.parse(state_definition)
    end

    new(states, start, steps)
  end

  def initialize(states, start, steps)
    @states = states.each_with_object({}) { |st, h| h[st.name] = st }
    @state = start
    @steps = steps
  end

  def run(tape)
    @steps.times do |step|
      #puts "#{tape} (after #{step} steps, about to run state #{@state})"
      current_state = @states.fetch(@state)
      transition = current_state.transition(tape.read)
      tape.write(transition.new_value)
      tape.move(transition.direction)
      @state = transition.next_state
    end
  end

end

TEST = File.read("test.txt")
INPUT = File.read("input.txt")

test_machine = Machine.parse(TEST)
p test_machine
test_tape = Tape.new
test_machine.run(test_tape)
puts test_tape.checksum

# Part 1

part1_machine = Machine.parse(INPUT)
pp part1_machine
part1_tape = Tape.new
part1_machine.run(part1_tape)
puts part1_tape.checksum
