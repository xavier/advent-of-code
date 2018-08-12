require "strscan"

InvalidState = Class.new(StandardError)
UnexpectedToken = Class.new(StandardError)

class StringScanner
  def scan!(regexp)
    scan(regexp) || (raise UnexpectedToken, "#{peek(10).inspect} did not match #{regexp.inspect}")
  end
end

class Stack < Array
  alias_method :peek, :last
end

class Group

  attr_reader :groups

  def initialize
    @groups = []
  end

  def score(depth = 1)
    depth + @groups.sum { |group| group.score(depth.succ) }
  end

end

class Scanner

  def initialize(input)
    @input = input
  end

  def scan
    scanner = StringScanner.new(@input)

    stack = Stack.new
    stack.push(Group.new)

    garbage = false

    while not scanner.eos?

      if garbage

        if scanner.scan(/>/)
          garbage = false

        elsif scanner.scan(/<+/)
          # Ignore

        elsif scanner.scan(/!./)
          # Skip escaped character

        elsif scanner.scan(/[^!>]+/)
          # Any other character

        else
          raise UnexpectedToken, scanner.peek(10)
        end

      else

        if scanner.scan(/{/)
          group = Group.new
          stack.peek.groups << group
          stack.push(group)

        elsif scanner.scan(/}/)
          stack.pop

        elsif scanner.scan(/,/)
          # Ignore

        elsif scanner.scan(/</)
          garbage = true

        else
          raise UnexpectedToken, scanner.peek(10)
        end

      end

    end

    stack.pop.groups.fetch(0)

  end

end


{
  "{}" => 1,
  "{{{}}}" => 6,
  "{{},{}}" => 5,
  "{{{},{},{{}}}}" => 16,
  "{<a>,<a>,<a>,<a>}" => 1,
  "{{<ab>},{<ab>},{<ab>},{<ab>}}" => 9,
  "{{<!!>},{<!!>},{<!!>},{<!!>}}" => 9,
  "{{<a!>},{<a!>},{<a!>},{<ab>}}" => 3
}.each do |input, expected_score|
  group = Scanner.new(input).scan
  puts "#{input} -> #{group.score} == #{expected_score}"
end

INPUT = File.read("input.txt").strip

puts Scanner.new(INPUT).scan.score
