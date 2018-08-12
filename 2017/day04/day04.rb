require "set"

def valid_part1?(passphrase)
  words = passphrase.split()
  words.count == Set.new(words).count
end

def valid_part2?(passphrase)
  words = passphrase.split().map { |word| word.chars.sort.join }
  words.count == Set.new(words).count
end

INPUT = File.read("input.txt").split("\n")

puts INPUT.count
puts INPUT.count { |passphrase| valid_part1?(passphrase) }
puts INPUT.count { |passphrase| valid_part2?(passphrase) }
