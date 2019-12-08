require_relative 'utils/utils'

original_input = File.read('input02.txt').chomp.split(',').map(&:to_i).freeze
input = original_input.dup
input[1] = 12
input[2] = 2

puts "Part 1: ", IntcodeComputer.run_program(input)[0]

puts "Part 2: "

def find_satisfactory_output(goal, original_input)
  (0..99).each do |noun|
    (0..99).each do |verb|
      input = original_input.dup
      input[1] = noun
      input[2] = verb

      return 100 * noun + verb if IntcodeComputer.run_program(input)[0] == goal
    end
  end
end

puts find_satisfactory_output(19690720, original_input)
