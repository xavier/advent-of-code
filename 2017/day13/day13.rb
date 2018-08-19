
class Firewall

  class Layer

    attr_reader :depth

    def initialize(depth, range)
      @depth = depth
      @range = range
    end

    def caught?(delay = 0)
      ((@depth + delay) % (@range * 2 - 2)).zero?
    end

    def severity
      @depth * @range
    end

  end

  class DummyLayer

    attr_reader :depth

    def initialize(depth)
      @depth = depth
    end

    def caught?(_delay)
      false
    end

    def severity
      0
    end

  end

  def self.parse(text)
    new(text.scan(/(\d+): (\d+)/).map { |tokens| tokens.map(&:to_i) })
  end

  def initialize(config)
    @layers = config.each_with_object({}) do |(depth, range), layers|
      layers[depth] = Layer.new(depth, range)
    end
    0.upto(@layers.keys.max) do |depth|
      @layers[depth] ||= DummyLayer.new(depth)
    end
  end

  def traverse(&block)
    Enumerator.new do |enum|
      @layers.keys.each do |depth|
        enum.yield(@layers.fetch(depth))
      end
    end
  end

end

class Scanner

  def initialize(firewall)
    @firewall = firewall
  end

  def scan(delay = 0)
    @firewall.traverse.reduce(0) do |trip_severity, layer|
      if layer.caught?(delay)
        trip_severity + layer.severity
      else
        trip_severity
      end
    end
  end

  def win?(delay)
    @firewall.traverse.none? { |layer| layer.caught?(delay) }
  end

end

def find_delay(scanner)
  delay = 1
  loop do
    puts delay if (delay % 1000).zero?
    return delay if scanner.win?(delay)
    delay += 1
  end
end

TEST = File.read("test.txt")

test_fw = Firewall.parse(TEST)
test_scan = Scanner.new(test_fw)
puts test_scan.scan
puts find_delay(test_scan)

INPUT = File.read("input.txt")

puzzle_fw = Firewall.parse(INPUT)
puzzle_scan = Scanner.new(puzzle_fw)
puts puzzle_scan.scan
puts find_delay(puzzle_scan)
