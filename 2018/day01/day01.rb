require "set"

INPUT = File.read("input.txt").split.map(&:to_i).freeze

# Part 1

def part1(input)
  input.reduce(&:+)
end

# Part 2

def repeat(input)
  Enumerator.new do |enum|
    idx = 0
    loop do
      enum.yield(input[idx % input.size])
      idx += 1
    end
  end
end

def part2(input)
  repeat(input)
    .reduce([0, Set.new]) do |(freq, freqs), change|
      freq += change
      if freqs.include?(freq)
        return freq
      else
        [freq, freqs.add(freq)]
      end
    end
end

#

puts part1(INPUT)
puts part2(INPUT)
