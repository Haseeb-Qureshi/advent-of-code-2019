require 'set'

class Sim
  attr_reader :grid
  EMPTY = '.'.freeze
  BUG = '#'.freeze

  def initialize(grid, print: false)
    @grid = grid
    @next_grid = grid.map(&:dup)
    @previous_layouts = Set.new([grid.join]) # can transform into number
    @print = print
  end

  def start!
    print if @print

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
        print if @print
        puts value
        return
      end

      @grid = @next_grid
      print if @Print
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

    unless things_adjacent_to(pos).count(BUG) == 1
      @next_grid[pos[0]][pos[1]] = EMPTY
    end
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

puts "Part 1"

input = "#..#.
.....
.#..#
.....
#.#.."

grid = input.lines.map(&:chomp).map(&:chars)

s = Sim.new(grid)
s.start!

puts "Part 2"

class MultidimensionalSim < Sim
  attr_reader :grids

  def initialize(grid)
    @grids = Array.new(400) { empty_grid }
    @grids[100] = grid
  end

  def start!(steps: 10)
    steps.times do
      @working_grids = @grids.map { |grid| grid.map(&:dup) }
      @grids.each_index do |grid_no|
        0.upto(4) do |x|
          0.upto(4) do |y|
            pos = [x, y]
            next if pos == [2, 2]
            bug_maybe_dies!(grid_no, pos)
            space_maybe_infests!(grid_no, pos)
          end
        end
      end
      @grids = @working_grids
    end

    puts total_bugs
  end

  private

  def empty_grid
    [("." * 5).chars] * 5
  end

  def print
    system "clear"
    @grids.each { |grid| grid.each { |line| puts line.join }; puts "-" * 5 }
  end

  def things_adjacent_to(grid_no, pos)
    x, y = pos
    immediate_adjacents = [
      [x - 1, y],
      [x + 1, y],
      [x, y + 1],
      [x, y - 1],
    ].reject { |i, j| [i, j] == [2, 2] }
     .select { |i, j| i.between?(0, 4) && j.between?(0, 4) }
     .map { |pos| at(grid_no, pos) }

    immediate_adjacents << at(grid_no - 1, [1, 2]) if x == 0 # top row, 8
    immediate_adjacents << at(grid_no - 1, [3, 2]) if x == 4 # bottom row, 18
    immediate_adjacents << at(grid_no - 1, [2, 1]) if y == 0 # left side, 12
    immediate_adjacents << at(grid_no - 1, [2, 3]) if y == 4 # right side, 14

    next_grid = @working_grids[grid_no + 1]

    return immediate_adjacents if next_grid.nil?

    case pos
    when [1, 2] # top row, 8
      immediate_adjacents.concat(next_grid[0]) # add the whole top row
    when [2, 1] # left column, 12
      immediate_adjacents.concat(next_grid.map(&:first))
    when [3, 2] # bottom row, 18
      immediate_adjacents.concat(next_grid[-1]) # add the whole top row
    when [2, 3] # right column, 14
      immediate_adjacents.concat(next_grid.map(&:last))
    end

    immediate_adjacents
  end

  def at(grid_no, pos)
    @grids[grid_no][pos[0]][pos[1]]
  end

  def bug_maybe_dies!(grid_no, pos)
    return unless at(grid_no, pos) == BUG

    unless things_adjacent_to(grid_no, pos).count(BUG) == 1
      @working_grids[grid_no][pos[0]][pos[1]] = EMPTY
    end
  end

  def space_maybe_infests!(grid_no, pos)
    return unless at(grid_no, pos) == EMPTY

    if things_adjacent_to(grid_no, pos).count(BUG).between?(1, 2)
      @working_grids[grid_no][pos[0]][pos[1]] = BUG
    end
  end

  def total_bugs
    @grids.sum { |grid| grid.flatten.count(BUG) }
  end
end

grid = input.lines.map(&:chomp).map(&:chars)

MultidimensionalSim.new(grid).start!(steps: 200)
