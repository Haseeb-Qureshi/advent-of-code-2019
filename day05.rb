# Opcode 3 takes a single integer as input and saves it to the position given by its only parameter. For example, the instruction 3,50 would take an input value and store it at address 50.
# Opcode 4 outputs the value of its only parameter. For example, the instruction 4,50 would output the value at address 50.
# Programs that use these instructions will come with documentation that explains what should be connected to the input and output. The program 3,0,4,0,99 outputs whatever it gets as input, then halts.

def run_program(tape, input, output)
  tape = tape.dup
  i = 0

  until i >= tape.length
    operand1 = tape[i + 1]
    operand2 = tape[i + 2]
    operand3 = tape[i + 3]

    digits = tape[i].digits.reverse.tap do |digits|
      digits.unshift(0) until digits.length == 5
    end
    opcode = digits[3] * 10 + digits[4]
    param1_immediate = !digits[2].zero?
    param2_immediate = !digits[1].zero?
    param3_immediate = !digits[0].zero?

    case opcode
    when 1
      op1 = param1_immediate ? operand1 : tape[operand1]
      op2 = param2_immediate ? operand2 : tape[operand2]
      tape[operand3] = op1 + op2
      i += 4
    when 2
      op1 = param1_immediate ? operand1 : tape[operand1]
      op2 = param2_immediate ? operand2 : tape[operand2]
      tape[operand3] = op1 * op2
      i += 4
    when 3
      tape[operand1] = input.read
      i += 2
    when 4
      op1 = param1_immediate ? operand1 : tape[operand1]
      output.write(op1)
      i += 2
    when 99
      break
    else
      p digits
      raise "Unexpected opcode at index #{i}: #{opcode}, #{tape[i]}"
    end
  end
  tape
end

class Reader
  def read
    gets.chomp.to_i
  end
end

class Writer
  def write(x)
    puts x
  end
end

puts "Part 1"
original_input = File.read('input05.txt').chomp.split(',').map(&:to_i).freeze
run_program(original_input, Reader.new, Writer.new)

puts "Part 2"
