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


def find_root(definitions)
  candidates = Set.new
  all_children = Set.new

  definitions.each do |name, weight, children|
    all_children.merge(children)
    candidates.add(name) if children.any?
  end

  (candidates - all_children).to_a.fetch(0)
end

TEST = parse(File.read("test.txt"))
INPUT = parse(File.read("input.txt"))

puts find_root(TEST)
puts find_root(INPUT)
