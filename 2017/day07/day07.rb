require "set"

def parse(text)
  text.split("\n").map { |line| parse_line(line) }
end

def parse_line(line)
  # gbyvdfh (155) -> xqmnq, iyoqt, dimle
  if line =~ /^([a-z]+) \((\d+)\)(?: -> (.*))?$/
    name = $1
    weight = $2.to_i
    children = $3 ? $3.split(", ") : []
    [name, weight, children]
  else
    raise ArgumentError
  end
end

TEST = parse(File.read("test.txt"))
INPUT = parse(File.read("input.txt"))

# Part 1

def find_root(definitions)
  candidates = Set.new
  all_children = Set.new

  definitions.each do |name, weight, children|
    all_children.merge(children)
    candidates.add(name) if children.any?
  end

  (candidates - all_children).to_a.fetch(0)
end

puts find_root(TEST)
puts find_root(INPUT)

# Part 2

Program = Struct.new(:name, :weight, :children)

class Tower

  attr_reader :programs

  def initialize(defintions)
    @programs = defintions.each_with_object({}) do |(name, weight, children), hash|
      hash[name] = Program.new(name, weight, children)
    end
  end

  def weigh(name)
    program = @programs.fetch(name)
    program.children.reduce(program.weight) { |total, child| total + weigh(child) }
  end

  def find_imbalance()
    @programs.keys.select { |name| !check_balance(name).nil? }
  end

  def check_balance(name)
    program = @programs.fetch(name)
    return if program.children.none?

    weights = program.children.each_with_object({}) { |child, hash| hash[child] = weigh(child) }
    return if weights.values.uniq.count == 1

    weights
  end

end

tower_test = Tower.new(TEST)

# p tower_test.check_balance("ugml")
# p tower_test.check_balance("padx")
# p tower_test.check_balance("fwft")
# p tower_test.check_balance("tknk")
#p tower_test.find_imbalance()

tower_input = Tower.new(INPUT)

# Narrow down
tower_input.find_imbalance().each do |name|
  puts name
  p tower_input.check_balance(name)
end

# Inspect weight to adjust
p tower_input.programs.fetch("egbzge")
