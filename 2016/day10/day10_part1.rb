
class Bot

  attr_writer :low, :high

  def initialize(id)
    @id         = id
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
    # Watch me :)
    raise "found #{@id}" if @values.sort == [17, 61]
    @low.receive(@values.min)
    @high.receive(@values.max)
    @values = []
  end

end

class Output

  attr_reader :value

  def initialize(id)
    @id    = id
    @value = nil
  end

  def receive(value)
    @value = value
  end

end


class Factory

  attr_reader :outputs

  def initialize
    @bots    = Hash.new { |h, k| h[k] = Bot.new(k) }
    @outputs = Hash.new { |h, k| h[k] = Output.new(k) }
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

  def run(steps = 10)
    steps.times do |step|
      @bots.each do |_, bot|
        bot.step!
      end
    end
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

# test = [
#   "value 5 goes to bot 2",
#   "bot 2 gives low to bot 1 and high to bot 0",
#   "value 3 goes to bot 1",
#   "bot 1 gives low to output 1 and high to bot 0",
#   "bot 0 gives low to output 2 and high to output 0",
#   "value 2 goes to bot 2]"
# ]

# factory = Factory.new.build(test)
# factory.run(3)

instructions = File.read("input.txt").split("\n")
factory = Factory.new.build(instructions)
factory.run(10)
