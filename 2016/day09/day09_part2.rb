require "strscan"

def calculate_decompressed_size(string)
  scanner = StringScanner.new(string)
  decompressed_size = 0
  until scanner.eos?
    char = scanner.scan(/[A-Z\(]/)
    if char == "("
      size = scanner.scan(/\d+/).to_i
      scanner.scan(/x/)
      count = scanner.scan(/\d+/).to_i
      scanner.scan(/\)/)
      repeated = scanner.scan(/.{#{size}}/)
      decompressed_size += count * calculate_decompressed_size(repeated)
    else
      decompressed_size += 1
    end
  end
  decompressed_size
end

#compressed_input = "X(8x2)(3x3)ABCY"
compressed_input = File.read("input.txt").gsub(/\s+/, "")
puts calculate_decompressed_size(compressed_input)
