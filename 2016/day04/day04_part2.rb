
class Room

  attr_reader :name, :letters, :sector_id

  def initialize(name)
    @name = name
    parse!
  end

  def real?
    @checksum == calculate_checksum
  end

  def decrypted_name
    lookup = build_cipher_lookup_table
    @letters
      .chars
      .map { |char| lookup.fetch(char) }
      .join
  end

  private

  FORMAT   = /\A([a-z]+(?:\-[a-z]+)*)-(\d+)\[([a-z]+)\]\z/
  ALPHABET = Array('a'..'z')

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

  def build_cipher_lookup_table
    shifted = ALPHABET.rotate(sector_id % ALPHABET.size)
    Hash[ALPHABET.zip(shifted)].merge("-" => " ")
  end

end

# puts Room.new("qzmt-zixmtkozy-ivhz-343[whatever]").decrypted_name

p File
  .read("input.txt")
  .split("\n")
  .to_enum
  .map { |line| Room.new(line) }
  .select { |room| room.real? }
  .map { |room| [room.decrypted_name, room.sector_id] }
  .select { |name, sector_id| name =~ /north/ }

