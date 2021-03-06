class Pos

  def initialize()
    @x, @y   = 0, 0
    @bearing = 0
  end

  def turn(dir)
    case dir
    when "R" then turn!(90)
    when "L" then turn!(-90)
    end
    self
  end

  def walk(dist)
    case @bearing
    when 0   then @y += dist
    when 90  then @x += dist
    when 180 then @y -= dist
    when 270 then @x -= dist
    end
    self
  end

  def distance
    @x.abs + @y.abs
  end

  private

  def turn!(angle)
    @bearing = (@bearing + angle) % 360
  end

end

def parse_instructions(input)
  case input
  when String then parse_instructions(input.split(", "))
  when Array  then input.map { |str| str =~ /([RL])(\d+)/; [$1, $2.to_i] }
  end
end

def find_destination(instructions)
  instructions
    .reduce(Pos.new) do |pos, (dir, dist)|
      pos.turn(dir).walk(dist)
      pos
    end
end

# p find_destination(parse_instructions(%w[R2 L3])).distance
# p find_destination(parse_instructions(%w[R2 R2 R2])).distance
# p find_destination(parse_instructions(%w[R5 L5 R5 R3])).distance

input = "R4, R3, L3, L2, L1, R1, L1, R2, R3, L5, L5, R4, L4, R2, R4, L3, R3, L3, R3, R4, R2, L1, R2, L3, L2, L1, R3, R5, L1, L4, R2, L4, R3, R1, R2, L5, R2, L189, R5, L5, R52, R3, L1, R4, R5, R1, R4, L1, L3, R2, L2, L3, R4, R3, L2, L5, R4, R5, L2, R2, L1, L3, R3, L4, R4, R5, L1, L1, R3, L5, L2, R76, R2, R2, L1, L3, R189, L3, L4, L1, L3, R5, R4, L1, R1, L1, L1, R2, L4, R2, L5, L5, L5, R2, L4, L5, R4, R4, R5, L5, R3, L1, L3, L1, L1, L3, L4, R5, L3, R5, R3, R3, L5, L5, R3, R4, L3, R3, R1, R3, R2, R2, L1, R1, L3, L3, L3, L1, R2, L1, R4, R4, L1, L1, R3, R3, R4, R1, L5, L2, R2, R3, R2, L3, R4, L5, R1, R4, R5, R4, L4, R1, L3, R1, R3, L2, L3, R1, L2, R3, L3, L1, L3, R4, L4, L5, R3, R5, R4, R1, L2, R3, R5, L5, L4, L1, L1"

instructions = parse_instructions(input)
destination = find_destination(instructions)
puts destination.distance




