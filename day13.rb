require_relative 'utils/utils'
require 'pry-nav'
require 'io/console'
require 'set'

TILES = {
  0 => :empty,
  1 => :wall,
  2 => :block,
  3 => :paddle,
  4 => :ball,
}

VIZ = {
  empty: ' ',
  wall: 'X',
  block: 'B',
  paddle: 'P',
  ball: 'O',
}

puts "Part 1"

class ScreenWriter
  def initialize
    @buffer = []
  end

  def write(input)
    if @buffer.length == 2
      x = @buffer.shift
      y = @buffer.shift
      tile_id = input
      draw_to_screen(x, y, tile_id)
    else
      @buffer << input
    end
  end

  def draw_to_screen(x, y, val)
    if x == -1 && y == 0 # display score
      $screen[29][29] = val
    else
      $screen[y][x] = VIZ[TILES[val]]
    end
  end
end

$screen = Array.new(30) { Array.new(30, VIZ[:empty]) }
program = File.read('input13.txt').split(',').map(&:to_i)
computer = IntcodeComputer.new(program, Reader.new, ScreenWriter.new)
computer.run_program

puts $screen.join.count(VIZ[:block])

puts "Part 2"

class InputReader < Struct.new(:human)
  def paddle_y
    $screen.map { |row| row.index(VIZ[:paddle]) }.find(&:itself)
  end

  def ball_y
    $screen.map { |row| row.index(VIZ[:ball]) }.find(&:itself)
  end

  def read
    if self.human
      system "clear"
      puts $screen.map(&:join)
      case STDIN.getch
      when 'a' then -1
      when 'd' then 1
      else 0
      end
    else
      case paddle_y <=> ball_y
      when -1 then 1
      when 1 then -1
      else 0
      end
    end
  end
end

program[0] = 2
computer = IntcodeComputer.new(program, InputReader.new(false), ScreenWriter.new)
computer.run_program

puts $screen[29][29]
