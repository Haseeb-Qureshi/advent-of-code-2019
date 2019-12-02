# Once you have a working computer, the first step is to restore the gravity assist program (your puzzle input) to the "1202 program alarm" state it had just before the last computer caught fire. To do this, before running the program, replace position 1 with the value 12 and replace position 2 with the value 2. What value is left at position 0 after the program halts?

def run_program(input)
  input = input.dup
  i = 0

  until i >= input.length
    next_opcode = input[i]
    case next_opcode
    when 1
      input[input[i + 3]] = input[input[i + 1]] + input[input[i + 2]]
      i += 4
    when 2
      input[input[i + 3]] = input[input[i + 1]] * input[input[i + 2]]
      i += 4
    when 99
      break
    else
      raise "Unexpected opcode at index #{i}: #{next_opcode}"
    end
  end
  input
end

original_input = File.read('input02.txt').chomp.split(',').map(&:to_i).freeze
input = original_input.dup
input[1] = 12
input[2] = 2

puts "Part 1: ", run_program(input)[0]

puts "Part 2: "

# "With terminology out of the way, we're ready to proceed. To complete the gravity assist, you need to determine what pair of inputs produces the output 19690720."
#
# The inputs should still be provided to the program by replacing the values at addresses 1 and 2, just like before. In this program, the value placed in address 1 is called the noun, and the value placed in address 2 is called the verb. Each of the two input values will be between 0 and 99, inclusive.
#
# Once the program has halted, its output is available at address 0, also just like before. Each time you try a pair of inputs, make sure you first reset the computer's memory to the values in the program (your puzzle input) - in other words, don't reuse memory from a previous attempt.
#
# Find the input noun and verb that cause the program to produce the output 19690720. What is 100 * noun + verb? (For example, if noun=12 and verb=2, the answer would be 1202.)

def find_satisfactory_output(goal, original_input)
  (0..99).each do |noun|
    (0..99).each do |verb|
      input = original_input.dup
      input[1] = noun
      input[2] = verb

      return 100 * noun + verb if run_program(input)[0] == goal
    end
  end
end

puts find_satisfactory_output(19690720, original_input)
