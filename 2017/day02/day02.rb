class Spreadsheet

  def self.parse(input)
    lines = input.strip.split("\n")
    rows = lines.map { |line| line.split("\t").map(&:to_i) }
    new(rows)
  end

  def initialize(rows)
    @rows = rows
  end

  def checksum_part1
    @rows.reduce(0) { |acc, row| acc + (row.max - row.min) }
  end

  def checksum_part2
    @rows.reduce(0) do |acc, row|
      acc + divisible_pair(row).reduce(&:/)
    end
  end

  private

  def divisible_pair(row)
    row.permutation(2).find { |(x, y)| x % y == 0 }
  end

end

test_part1 = Spreadsheet.parse("5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8\n")
puts test_part1.checksum_part1

test_part2 = Spreadsheet.parse("5\t9\t2\t8\n9\t4\t7\t3\n3\t8\t6\t5\n")
puts test_part2.checksum_part2

input = Spreadsheet.parse(File.read("input.txt"))
puts input.checksum_part1
puts input.checksum_part2
