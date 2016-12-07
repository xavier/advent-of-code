
def find_triplets(text)
  text
    .chars
    .each_cons(3)
    .select { |a, b, c| (a != b) && (a == c) }
    .map { |triplet| triplet.join }
end

def aba_to_bab(aba)
  a, b = aba.chars[0, 2]
  "#{b}#{a}#{b}"
end

def ssl?(text)
  inside  = text.scan(/\[([^\]]*)\]/).flatten.join("---")
  outside = text.gsub(/\[[^\]]*\]/, "---")
  abas = find_triplets(outside)
  babs = find_triplets(inside)
  abas.any? { |aba| babs.include?(aba_to_bab(aba)) }
end

puts File
  .read("input.txt")
  .split("\n")
  .count { |line| ssl?(line) }
