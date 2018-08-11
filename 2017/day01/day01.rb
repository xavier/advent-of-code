
class String
  def digits
    split("").map(&:to_i)
  end
end

def sum(digits, steps)
  digits
    .each_with_index
    .reduce(0) do |acc, (digit, index)|
      next_digit = digits[(index + steps) % digits.length]
      digit == next_digit ? acc + digit : acc
    end
end

def sum_part1(digits)
  sum(digits, 1)
end

def sum_part2(digits)
  sum(digits, digits.length / 2)
end

INPUT = File.read("input.txt").strip.digits

# Part 1
# puts sum_part1("1122".digits)
# puts sum_part1("1111".digits)
# puts sum_part1("1234".digits)
# puts sum_part1("91212129".digits)
puts sum_part1(INPUT)

# Part 2
#puts sum_part2("1212".digits)
#puts sum_part2("1221".digits)
#puts sum_part2("123425".digits)
#puts sum_part2("123123".digits)
#puts sum_part2("12131415".digits)
puts sum_part2(INPUT)
