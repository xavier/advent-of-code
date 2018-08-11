class Spreadsheet

  def self.parse(input)
    lines = input.strip.split("\n")
    rows = lines.map { |line| line.split("\t").map(&:to_i) }
    new(rows)
  end

  def initialize(rows)
    @rows = rows
  end

  def checksum
    @rows.reduce(0) { |acc, row| acc + (row.max - row.min) }
  end


end

test = Spreadsheet.parse("5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8\n")
puts test.checksum

input = Spreadsheet.parse(File.read("input.txt"))
puts input.checksum
