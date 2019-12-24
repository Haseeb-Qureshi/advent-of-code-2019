require 'set'

puts "Part 1"

class Sim
  attr_reader :grid
  EMPTY = '.'.freeze
  BUG = '#'.freeze

  def initialize(grid)
    @grid = grid
    @next_grid = grid.map(&:dup)
    @previous_layouts = Set.new([grid.join]) # can transform into number
  end

  def start!
    print

    0.upto(Float::INFINITY) do |i|
      @next_grid = grid.map(&:dup)

      @grid.each_index do |i|
        @grid[0].each_index do |j|
          pos = [i, j]
          bug_maybe_dies!(pos)
          space_maybe_infests!(pos)
        end
      end

      if seen_before?
        @grid = @next_grid
        print
        puts "I have seen it on the #{i}th iteration! The value is: #{value}"
        return
      end

      @grid = @next_grid
      print
    end
  end

  private

  def seen_before?
    return true if @previous_layouts.include?(@next_grid.join)
    @previous_layouts << @next_grid.join
    false
  end

  def print
    system "clear"
    @grid.each { |line| puts line.join }
    puts "-" * 5
  end

  def adjacents(pos)
    x, y = pos
    arr = [
      [x - 1, y],
      [x + 1, y],
      [x, y + 1],
      [x, y - 1],
    ].select do |i, j|
      i.between?(0, @grid.length - 1) && j.between?(0, @grid[0].length - 1)
    end
  end

  def things_adjacent_to(pos)
    adjacents(pos).map { |new_pos| at(new_pos) }
  end

  def at(pos)
    @grid[pos[0]][pos[1]]
  end

  def bug_maybe_dies!(pos)
    return unless at(pos) == BUG

    @next_grid[pos[0]][pos[1]] = EMPTY unless things_adjacent_to(pos).count(BUG) == 1
  end

  def space_maybe_infests!(pos)
    return unless at(pos) == EMPTY

    if things_adjacent_to(pos).count(BUG).between?(1, 2)
      @next_grid[pos[0]][pos[1]] = BUG
    end
  end

  def value
    @grid.flatten.map.with_index do |c, i|
      c == BUG ? 2 ** i : 0
    end.sum
  end
end


input = "#..#.
.....
.#..#
.....
#.#.."

grid = input.lines.map(&:chomp).map(&:chars)

s = Sim.new(grid)
s.start!
