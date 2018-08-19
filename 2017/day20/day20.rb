
class Vector

  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def add(other)
    @x += other.x
    @y += other.y
    @z += other.z
    self
  end

  def magnitude
    Math.sqrt(@x * @x + @y * @y + @z * @z)
  end

  def to_s
    "<#{@x}, #{@y}, #{@z}>"
  end

  def to_a
    [@x, @y, @z]
  end

end

class Particle

  attr_reader :id, :pos, :vel, :acc

  def initialize(id, pos, vel, acc)
    @id = id
    @pos = pos
    @vel = vel
    @acc = acc
  end

  def tick
    @vel.add(@acc)
    @pos.add(@vel)
  end

  def distance
    @pos.x.abs + @pos.y.abs + @pos.z.abs
  end

  def collides?(other)
    (@pos.x == other.x) && (@pos.y == other.y) && (@pos.z == other.z)
  end

end

class World

  attr_reader :particles

  def initialize(particles)
    @particles = particles
  end

  def tick
    @particles.each(&:tick)
  end

  def part1(rounds)
    rounds.times { tick }
    @particles.min_by(&:distance)
  end

  def part2(rounds)
    rounds.times do
      tick
      @particles = reject_collisions(@particles)
    end
    @particles.size
  end

  private

  def reject_collisions(particles)
    particles
      .group_by { |particle| particle.pos.to_a }
      .reject { |_pos, particles| particles.size > 1 }
      .values
      .flatten
  end

end

def parse(text)
  text
    .scan(/p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/)
    .each_with_index
    .map do |tokens, index|
      Particle.new(
        index,
        *tokens
          .map(&:to_i)
          .each_slice(3)
          .map { |coords| Vector.new(*coords) }
      )
    end
end

INPUT = File.read("input.txt")

world = World.new(parse(INPUT))
p world.part1(100000)
p world.part2(5000)
