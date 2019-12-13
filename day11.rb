require_relative 'utils/utils'
require 'pry-nav'
require 'set'

DIRECTIONS = [:up, :right, :down, :left] + [:up, :right, :down, :left]
DELTAS = {
  up: [-1, 0],
  right: [0, 1],
  down: [1, 0],
  left: [0, -1],
}
BLACK = '.'.freeze
WHITE = '#'.freeze

def turn_left(dir, x, y)
  new_dir = DIRECTIONS[DIRECTIONS.index(dir) - 1]
  dx, dy = DELTAS[new_dir]
  [new_dir, x + dx, y + dy]
end

def turn_right(dir, x, y)
  new_dir = DIRECTIONS[DIRECTIONS.index(dir) + 1]
  dx, dy = DELTAS[new_dir]
  [new_dir, x + dx, y + dy]
end

puts "Part 1"

$state = [:up, 40, 40]
$grid = Array.new(100) { Array.new(100, BLACK) }
$panels_painted = Set.new

program = File.read('input11.txt').split(',').map(&:to_i)

class GridFeeder
  def read
    $grid[$state[1]][$state[2]] == BLACK ? 0 : 1
  end
end

class InstructionProcessor
  def write(x)
    @first_write = !@first_write

    if @first_write
      $panels_painted << $state.drop(1)
      if x == 0 # paint the panel black
        $grid[$state[1]][$state[2]] = BLACK
      else # paint the panel white
        $grid[$state[1]][$state[2]] = WHITE
      end
    else
      if x == 0 # turn left
        $state = turn_left(*$state)
      else # turn right
        $state = turn_right(*$state)
      end
    end
  end
end

computer = IntcodeComputer.new(program, GridFeeder.new, InstructionProcessor.new)
computer.run_program
puts $panels_painted.size

puts "Part 2"
$state = [:up, 40, 40]
$grid = Array.new(100) { Array.new(100, BLACK) }
$grid[$state[1]][$state[2]] = WHITE
$panels_painted = Set.new

computer = IntcodeComputer.new(program, GridFeeder.new, InstructionProcessor.new)
computer.run_program
puts $grid.map(&:join)
