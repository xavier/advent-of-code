require "set"

def valid?(passphrase)
  words = passphrase.split()
  words.count == Set.new(words).count
end

INPUT = File.read("input.txt").split("\n")

puts INPUT.count
puts INPUT.count { |passphrase| valid?(passphrase) }
