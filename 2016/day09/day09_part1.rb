require "strscan"

def decompress(string)
  scanner = StringScanner.new(string)
  out = ""
  until scanner.eos?
    char = scanner.scan(/[A-Z\(]/)
    if char == "("
      size = scanner.scan(/\d+/).to_i
      scanner.scan(/x/)
      count = scanner.scan(/\d+/).to_i
      scanner.scan(/\)/)
      repeated = scanner.scan(/.{#{size}}/)
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


