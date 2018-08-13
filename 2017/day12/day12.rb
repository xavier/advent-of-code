require "set"

class PipeNetwork

  def self.parse(lines)
    new(
      lines.each_with_object({}) do |line, pipes|
        ids = line.split(/\s*(?:<->|,)\s*/).map(&:to_i)
        pipes[ids.shift] = ids
      end
    )
  end

  def initialize(pipes)
    @pipes = pipes
  end

  def groups
    @pipes.keys.reduce(Set.new) do |set, id|
      set << group(id)
    end
  end

  def group(id, init_set = nil)
    @pipes
      .fetch(id)
      .reduce(init_set || Set.new([id])) do |set, other_id|
        if set.include?(other_id)
          set
        else
          set.union(group(other_id, set << other_id))
        end
      end
  end

end

TEST = File.read("test.txt").split("\n")
INPUT = File.read("input.txt").split("\n")

test = PipeNetwork.parse(TEST)
p test.group(0)
p test.groups()

puzzle = PipeNetwork.parse(INPUT)
puts puzzle.group(0).size
puts puzzle.groups.size
