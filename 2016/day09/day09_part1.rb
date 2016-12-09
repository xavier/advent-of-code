
class UnexpectedToken < StandardError
end

class Scanner

  def initialize(string)
    @string = string
  end

  def consume(pattern)
    case pattern
    when Fixnum
      consumed = @string.slice(0, pattern)
      skip(pattern)
      consumed
    when String
      if @string.start_with?(pattern)
        skip(pattern.size)
        pattern
      else
        raise UnexpectedToken, "#{pattern} at #{@string[0, 20].inspect}..."
      end
    when Regexp
      if @string =~ pattern
        skip($1.size)
        $1
      else
        raise UnexpectedToken, "#{pattern} at #{@string[0, 20].inspect}..."
      end
    end
  end

  def skip(count = 1)
    @string = @string.slice(count..-1) || ""
  end

  def number
    consume(/\A(\d+)/).to_i
  end

  def done?
    @string.empty?
  end

end

def decompress(string)
  scanner = Scanner.new(string)
  out = ""
  until scanner.done?
    char = scanner.consume(1)
    if char == "("
      size = scanner.number
      scanner.consume("x")
      count = scanner.number
      scanner.consume(")")
      repeated = scanner.consume(size)
      out << (repeated * count)
    else
      out << char
    end
  end
  out
end

# {
#   "ADVENT"            => "ADVENT",
#   "A(1x5)BC"          => "ABBBBBC",
#   "(3x3)XYZ"          => "XYZXYZXYZ",
#   "A(2x2)BCD(2x2)EFG" => "ABCBCDEFEFG",
#   "(6x1)(1x3)A"       => "(1x3)A",
#   "X(8x2)(3x3)ABCY"   => "X(3x3)ABC(3x3)ABCY"
# }.each do |compressed, expected|
#   decompressed = decompress(compressed)
#   puts "#{compressed} == #{decompressed} --> #{decompressed == expected}"
# end

compressed_input = File.read("input.txt").gsub(/\s+/, "")
puts decompress(compressed_input).size
