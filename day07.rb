require_relative 'utils/utils'

PHASE_SETTINGS = (0..4)
file = File.read('input07.txt')
file = '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'
tape = file.chomp.split(',').map(&:to_i)

class TwoInputReader < Struct.new(:input1, :input2)
  def read
    # raise "Read too many times!" if @read_more_than_twice
    if !@second_read
      @second_read = true
      input1
    else
      @read_more_than_twice = true
      input2
    end
  end
end

class WriterCapsule < Struct.new(:val, :written)
  def write(x)
    self.written = true
    self.val = x
  end
end

def phase_set(tape, a, b, c, d, e)
  capsule = WriterCapsule.new
  IntcodeComputer.run_program(tape, TwoInputReader.new(a, 0), capsule)
  [b, c, d, e].each do |amp|
    IntcodeComputer.run_program(tape, TwoInputReader.new(amp, capsule.val), capsule)
  end
  capsule.val
end

def max_thruster(tape)
  PHASE_SETTINGS.to_a.permutation(5).lazy.map do |a, b, c, d, e|
    phase_set(tape, a, b, c, d, e)
  end.max
end

puts "Part 1"
puts max_thruster(tape)

puts "Part 2"
NEW_PHASE_SETTINGS = (5..9)

def phase_set_with_feedback(tape, a, b, c, d, e)
  capsule = WriterCapsule.new
  IntcodeComputer.run_program(tape, TwoInputReader.new(a, 0), capsule)
  [b, c, d, e].each do |amp|
    capsule = WriterCapsule.new(capsule.val)
    IntcodeComputer.run_program(tape, TwoInputReader.new(amp, capsule.val), capsule)
  end
  loop do
    break unless capsule.written
    [a, b, c, d, e].each do |amp|
      capsule = WriterCapsule.new(capsule.val)
      IntcodeComputer.run_program(tape, TwoInputReader.new(amp, capsule.val), capsule)
    end
  end
  capsule.val
end

def max_feedback_thruster(tape)
  NEW_PHASE_SETTINGS.to_a.permutation(5).lazy.map do |a, b, c, d, e|
    phase_set_with_feedback(tape, a, b, c, d, e)
  end.max
end

puts max_feedback_thruster(tape)
