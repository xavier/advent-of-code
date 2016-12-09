
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

def calculate_decompressed_size(string, level = 0)
  scanner = Scanner.new(string)
  decompressed_size = 0
  until scanner.done?
    char = scanner.consume(1)
    if char == "("
      size = scanner.number
      scanner.consume("x")
      count = scanner.number
      scanner.consume(")")
      repeated = scanner.consume(size)
      decompressed_size += count * calculate_decompressed_size(repeated, level + 1)
    else
      decompressed_size += 1
    end
  end
  decompressed_size
end

#compressed_input = "X(8x2)(3x3)ABCY"
compressed_input = File.read("input.txt").gsub(/\s+/, "")
puts calculate_decompressed_size(compressed_input)
