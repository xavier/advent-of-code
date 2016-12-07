
def abba?(text)
  index = text =~ /(.)(.)(\2\1)/
  index ? text[index, 4] !~ /#{$1}{4}/ : false
end

def tls?(text)
  inside  = text.scan(/\[([^\]]*)\]/).map { |match,| match }.join(" ")
  outside = text.gsub(/\[[^\]]*\]/, " ")
  abba?(outside) && !abba?(inside)
end

puts File
  .read("input.txt")
  .split("\n")
  .count { |line| tls?(line) }
