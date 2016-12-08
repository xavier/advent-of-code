
class Display

  def initialize(width, height)
    @width  = width
    @height = height
    @pixels = height.times.map { [false] * width }
  end

  def rect(w, h)
    h.times do |y|
      w.times do |x|
        set(x, y)
      end
    end
  end

  def rotate_column(x, offset)
    offset.times do
      carry = get(x, @height-1)
      (@height-1).downto(1).each do |y|
        set(x, y, get(x, y-1))
      end
      set(x, 0, carry)
    end
  end

  def rotate_row(y, offset)
    @pixels.fetch(y).rotate!(-offset)
  end

  def to_s
    @pixels.map do |row|
      row.map { |pixel| pixel ? "#" : "." }.join
    end.join("\n")
  end

  def count_lit
    @pixels.reduce(0) do |total, row|
      total + row.count { |pixel| pixel }
    end
  end

  private

  def get(x, y)
    @pixels.fetch(y).fetch(x)
  end

  def set(x, y, on = true)
    @pixels.fetch(y)[x] = on
  end

end

def interpret(instruction, display)
  case instruction
  when /rect (\d+)x(\d+)/
    display.rect($1.to_i, $2.to_i)
  when /rotate row y=(\d+) by (\d+)/
    display.rotate_row($1.to_i, $2.to_i)
  when /rotate column x=(\d+) by (\d+)/
    display.rotate_column($1.to_i, $2.to_i)
  end
  display
end

# display = Display.new(7, 3)
# display.rect(3, 2)
# puts display
# display.rotate_column(1, 1)
# puts display
# display.rotate_row(0, 4)
# puts display
# display.rotate_column(1, 1)
# puts display
# puts display.count_lit

puts File
  .read("input.txt")
  .split("\n")
  .reduce(Display.new(50, 6)) { |display, instruction| interpret(instruction, display) }
  .count_lit
