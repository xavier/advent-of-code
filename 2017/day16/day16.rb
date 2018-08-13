
class Dance

  attr_reader :programs

  def initialize(programs)
    @programs = Array(programs)
  end

  def perform(moves)
    moves.each { |move| perform_move(move) }
    self
  end

  def to_s
    @programs.join
  end

  private

  def perform_move(move)
    case move
    when /s(\d+)/
      spin($1.to_i)

    when /x(\d+)\/(\d+)/
      exchange($1.to_i, $2.to_i)

    when /p([a-z]+)\/([a-z]+)/
      partner($1, $2)

    else
      raise ArgumentError
    end
  end

  def spin(n)
    head = @programs.slice(0..-(n+1))
    tail = @programs.slice(-n..-1)
    @programs = tail + head
  end

  def exchange(i, j)
    @programs[j], @programs[i] = @programs[i], @programs[j]
  end

  def partner(a, b)
    exchange(@programs.index(a), @programs.index(b))
  end

end

# dance = Dance.new("a".."e")
# puts dance


INPUT = File.read("input.txt").strip.split(",")

dance = Dance.new("a".."p")

puts dance.perform(INPUT).to_s
