
class Firewall

  class Layer

    attr_reader :depth

    def initialize(depth, range)
      @depth = depth
      @range = range
      @position = 0
      @direction = -1
    end

    def caught?
      @position.zero?
    end

    def severity
      @depth * @range
    end

    def tick!
      @direction = -@direction if @position.zero? || @position == (@range-1)
      @position += @direction
    end

    def to_s
      "<Layer:#{@depth}/#{@range} #{@position}>"
    end

  end

  class DummyLayer

    attr_reader :depth

    def initialize(depth)
      @depth = depth
    end

    def caught?
      false
    end

    def severity
      0
    end

    def to_s
      "<D:#{@depth}>"
    end

  end

  def self.parse(text)
    new(text.scan(/(\d+): (\d+)/).map { |tokens| tokens.map(&:to_i) })
  end

  def initialize(config)
    @layers = config.each_with_object({}) do |(depth, range), hash|
      hash[depth] = Layer.new(depth, range)
    end
    @picosecond = 0
  end

  def tick!
    @layers.values.each(&:tick!)
    @picosecond += 1
  end

  def traverse(&block)
    Enumerator.new do |enum|
      layers.each do |layer|
        enum.yield(layer)
        tick!
      end
    end
  end

  def layers
    0.upto(@layers.keys.max).map do |depth|
      @layers.fetch(depth, DummyLayer.new(depth))
    end
  end

  def to_s
    layers.map { |layer| layer.to_s }.join("\n")
  end

end

class Scanner

  def initialize(firewall)
    @firewall = firewall
  end

  def scan()
    @firewall.traverse.reduce(0) do |trip_severity, layer|
      if layer.caught?
        trip_severity + layer.severity
      else
        trip_severity
      end
    end
  end

  def win?(delay)
    delay.times { @firewall.tick! }
    @firewall.traverse.none? { |layer| layer.caught? }
  end

end

def find_delay(config)
  delay = 0
  loop do
    fw = Firewall.parse(config)
    return delay if Scanner.new(fw).win?(delay)
    delay += 1
  end
end

TEST = File.read("test.txt")

test_fw = Firewall.parse(TEST)
test_scan = Scanner.new(test_fw)
puts test_scan.scan
puts find_delay(TEST)

INPUT = File.read("input.txt")

puzzle_fw = Firewall.parse(INPUT)
puzzle_scan = Scanner.new(puzzle_fw)
puts puzzle_scan.scan
puts find_delay(INPUT)
