require "digest"

class Position < Struct.new(:x, :y)

  def move(direction)
    case direction
    when "U" then Position.new(x, y - 1)
    when "D" then Position.new(x, y + 1)
    when "L" then Position.new(x - 1, y)
    when "R" then Position.new(x + 1, y)
    end
  end

  def to_s
    "(#{x}, #{y})"
  end

end

class Vault

  def initialize(passcode)
    @passcode    = passcode
    @destination = Position.new(3, 3)
  end

  def shortest_path
    find_shortest_path(Position.new(0, 0), [])
  end

  def longest_path
    find_longest_path(Position.new(0, 0), [])
  end

  def find_shortest_path(position, path)
    if position == @destination
      path
    else
      open_doors(path)
        .select { |door| move_allowed?(position, door) }
        .map { |door| find_shortest_path(position.move(door), path + [door]) }
        .compact
        .min_by { |path| path.size }
    end
  end

  def find_longest_path(position, path)
    if position == @destination
      path
    else
      open_doors(path)
        .select { |door| move_allowed?(position, door) }
        .map { |door| find_longest_path(position.move(door), path + [door]) }
        .compact
        .max_by { |path| path.size }
    end
  end

  DOOR_OPEN_CHARS = "b".."f"

  def move_allowed?(position, direction)
    case direction
    when "U" then position.y > 0
    when "D" then position.y < 3
    when "L" then position.x > 0
    when "R" then position.x < 3
    end
  end

  def open_doors(path)
    digest(path)
      .slice(0, 4)
      .chars
      .zip(%w[U D L R])
      .each_with_object([]) do |(char, door), doors|
        doors << door if DOOR_OPEN_CHARS.include?(char)
      end
  end

  def digest(path)
    Digest::MD5.hexdigest(@passcode + path.join)
  end

end

# {
#   "ihgpwlah" => ["DDRRRD", 370],
#   "kglvqrro" => ["DDUDRLRRUDRD", 492],
#   "ulqzkmiv" => ["DRURDRUDDLLDLUURRDULRLDUUDDDRR", 830],
# }.each do |input, (expected_shortest, expected_longest_size)|
#   vault = Vault.new(input)
#   shortest = vault.shortest_path
#   longest  = vault.longest_path
#   puts "#{input}: shortest=#{shortest.join == expected_shortest}, longest=#{longest.size == expected_longest_size}"
# end

vault = Vault.new("pxxbnzuo")

# Part 1
# puts vault.shortest_path.join

# Part 2
puts vault.longest_path.size
