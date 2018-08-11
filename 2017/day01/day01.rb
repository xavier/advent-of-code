
class String
  def digits
    split("").map(&:to_i)
  end
end

def sum(digits)
  digits
    .each_with_index
    .reduce(0) do |acc, (digit, index)|
      next_digit = digits[index.succ % digits.length]
      digit == next_digit ? acc + digit : acc
    end
end

# puts sum("1122".digits)
# puts sum("1111".digits)
# puts sum("1234".digits)
# puts sum("91212129".digits)

INPUT = File.read("input.txt").strip

puts sum(INPUT.digits)
