require_relative 'utils/utils'
require 'pry-nav'

PHASE_SETTINGS = (0..4)
# DEBUG = true
file = File.read('input07.txt')
file = '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'
tape = file.chomp.split(',').map(&:to_i).freeze

class MultiInputReader
  def initialize(*inputs)
    @inputs = inputs
    @counter = 0
  end

  def read
    @counter += 1
    @inputs[@counter] || @inputs.last # overflow!
  end
end

class WriterCapsule < Struct.new(:val, :written, :halted)
  def write(x)
    self.written = true
    self.val = x
  end

  def halt
    self.halted = true
  end
end

def phase_set(tape, a, b, c, d, e)
  capsule = WriterCapsule.new
  IntcodeComputer.run_program(tape, MultiInputReader.new(a, 0), capsule)
  [b, c, d, e].each do |amp|
    IntcodeComputer.run_program(tape, MultiInputReader.new(amp, capsule.val), capsule)
  end
  capsule.val
end

def max_thruster(tape)
  PHASE_SETTINGS.to_a.permutation(5).lazy.map do |a, b, c, d, e|
    phase_set(tape, a, b, c, d, e)
  end.max
end

puts "Part 1"
# puts max_thruster(tape)

puts "Part 2"
NEW_PHASE_SETTINGS = (5..9)

def initialize_computer(tape, val1, val2)
  computer = IntcodeComputer.new(tape, MultiInputReader.new(val1, val2), WriterCapsule.new)
  computer.execute_next_instruction until computer.output.written
  computer
end

def continue_to_next_input(computer, new_input)
  computer.input = MultiInputReader.new(new_input)
  computer.execute_next_instruction until computer.output.written
end

def phase_set_with_feedback(tape, a, b, c, d, e)
  halted = false

  computer_a = initialize_computer(tape, a, 0)
  computer_b = initialize_computer(tape, b, computer_a.output.val)
  computer_c = initialize_computer(tape, c, computer_b.output.val)
  computer_d = initialize_computer(tape, d, computer_c.output.val)
  computer_e = initialize_computer(tape, e, computer_d.output.val)

  i = 0
  loop do
    i += 1
    # print i
    break if computer_e.terminated
    continue_to_next_input(computer_a, computer_e.output.val)
    continue_to_next_input(computer_b, computer_a.output.val)
    continue_to_next_input(computer_c, computer_b.output.val)
    continue_to_next_input(computer_d, computer_c.output.val)
    continue_to_next_input(computer_e, computer_d.output.val)
  end
  capsule.val
end

def max_feedback_thruster(tape)
  NEW_PHASE_SETTINGS.to_a.permutation(5).lazy.map do |a, b, c, d, e|
    phase_set_with_feedback(tape, a, b, c, d, e)
  end.max
end

puts phase_set_with_feedback(tape, 9, 8, 7, 6, 5)

p "Oh snap"

puts max_feedback_thruster(tape)
