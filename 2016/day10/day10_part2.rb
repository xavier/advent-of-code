
class Bot

  attr_writer :low, :high

  def initialize
    @values     = []
    @low, @high = nil, nil
  end

  def receive(new_value)
    @values << new_value
  end

  def step!
    give_values! if @values.size == 2
  end

  private

  def give_values!
    @low.receive(@values.min)
    @high.receive(@values.max)
    @values = []
  end

end

class Output

  attr_reader :value

  def initialize
    @value = nil
  end

  def empty?
    @value.nil?
  end

  def receive(value)
    @value = value
  end

end


class Factory

  attr_reader :outputs

  def initialize
    @bots    = Hash.new { |h, k| h[k] = Bot.new }
    @outputs = Hash.new { |h, k| h[k] = Output.new }
  end

  def build(instructions)
    instructions.each do |instruction|
      case instruction
      when /value (\d+) goes to bot (\d+)/
        @bots[$2.to_i].receive($1.to_i)
      when /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
        giver      = @bots[$1.to_i]
        giver.low  = recipient($2, $3.to_i)
        giver.high = recipient($4, $5.to_i)
      end
    end
    self
  end

  def run
    until goal_reached?
      @bots.each do |_, bot|
        bot.step!
      end
    end
  end

  def goal_reached?
    required_outputs.none? { |output| output.empty? }
  end

  def required_outputs
    (0..2).map { |id| @outputs[id] }
  end

  private

  def recipient(recipient_type, recipient_id)
    case recipient_type
    when "bot"    then @bots[recipient_id]
    when "output" then @outputs[recipient_id]
    else
      raise ArgumentError, "#{recipient_type} #{recipient_id}"
    end
  end

end

instructions = File.read("input.txt").split("\n")
factory = Factory.new.build(instructions)
factory.run

puts factory.required_outputs.map(&:value).reduce(:*)
