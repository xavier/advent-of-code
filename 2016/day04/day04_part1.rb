
class Room

  attr_reader :name, :letters, :sector_id

  def initialize(name)
    @name = name
    parse!
  end

  def real?
    @checksum == calculate_checksum
  end

  private

  FORMAT = /\A([a-z]+(?:\-[a-z]+)*)-(\d+)\[([a-z]+)\]\z/

  def parse!
    @name =~ FORMAT
    @letters   = $1
    @sector_id = $2.to_i
    @checksum  = $3
  end

  def calculate_checksum
    letters_frequency
      .map { |letter, freq| [-freq, letter] }
      .sort
      .take(5)
      .reduce("") { |sum, (_, letter)| sum << letter }
  end

  def letters_frequency
    @letters
      .chars
      .each_with_object(Hash.new { |h, k| h[k] = 0 }) do |letter, freq|
        freq[letter] += 1 unless letter == "-"
      end
  end

end

# {
#   "aaaaa-bbb-z-y-x-123[abxyz]"   => true,
#   "a-b-c-d-e-f-g-h-987[abcde]"   => true,
#   "not-a-real-room-404[oarel]"   => false,
#   "totally-real-room-200[decoy]" => false
# }.each do |input, expected|
#   room = Room.new(input)
#   puts "#{input}: #{expected} #{Room.new(input).real?}"
# end

puts File
  .read("input.txt")
  .split("\n")
  .map { |line| Room.new(line) }
  .select { |room| room.real? }
  .reduce(0) { |sum, room| sum + room.sector_id }
