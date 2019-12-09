DEBUG = false
PRY = false
POSITION = 0
IMMEDIATE = 1
RELATIVE = 2

class IntcodeComputer
  attr_accessor :tape, :input, :output, :terminated
  def self.run_program(tape, input = Reader.new, output = Writer.new)
    IntcodeComputer.new(tape, input, output).run_program
  end

  def initialize(tape, input, output)
    @tape = Tape.new(tape.dup)
    @input = input
    @output = output
    @i = 0
    @shift = 0
    @terminated = false
  end

  def run_program
    p @tape.tape if DEBUG
    until @i >= @tape.tape.length || @terminated
      execute_next_instruction
    end
    @tape.tape
  end

  def execute_next_instruction
    @operand1 = @tape[@i + 1]
    @operand2 = @tape[@i + 2]
    @operand3 = @tape[@i + 3]

    digits = @tape[@i].digits.reverse.tap do |digits|
      digits.unshift(0) until digits.length == 5
    end
    @opcode = digits[3] * 10 + digits[4]

    @mode1, @mode2, @mode3 = digits[2], digits[1], digits[0]

    sleep 0.6 if DEBUG
    p @tape.tape[@i..@i + 3] if DEBUG
    binding.pry if PRY

    case @opcode
    when 1 # add
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      op3 = adjust_address_operator_for_mode(@operand3, @mode3)
      puts "Adding #{op1} and #{op2} into slot #{op3}" if DEBUG
      @tape[op3] = op1 + op2
      @i += 4
    when 2 # multiply
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      op3 = adjust_address_operator_for_mode(@operand3, @mode3)
      puts "Multiplying #{op1} and #{op2} into slot #{op3}" if DEBUG
      @tape[op3] = op1 * op2
      @i += 4
    when 3 # gets
      # Ugly hack here to make sure relative mode gets set correctly here
      op1 = adjust_address_operator_for_mode(@operand1, @mode1)
      puts "Reading input into slot #{@operand1}" if DEBUG
      @tape[op1] = @input.read
      @i += 2
    when 4 # puts
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      puts "Writing #{op1}" if DEBUG
      @output.write(op1)
      @i += 2
    when 5 # jump if true
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      puts "Jumping to #{op2} if #{op1} > 0" if DEBUG
      if !op1.zero?
        @i = op2
      else
        @i += 3
      end
    when 6 # jump if false
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      puts "Jumping to #{op2} if #{op1} == 0" if DEBUG
      if op1.zero?
        @i = op2
      else
        @i += 3
      end
    when 7 # less than?
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      op3 = adjust_address_operator_for_mode(@operand3, @mode3)
      puts "Placing whether #{op1} < #{op2} into slot #{op3}" if DEBUG
      @tape[op3] = op1 < op2 ? 1 : 0
      @i += 4
    when 8 # equals?
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      op2 = adjust_operator_for_mode(@operand2, @mode2)
      op3 = adjust_address_operator_for_mode(@operand3, @mode3)
      puts "Placing whether #{op1} == #{op2} into slot #{op3}" if DEBUG
      @tape[op3] = op1 == op2 ? 1 : 0
      @i += 4
    when 9 # add to relative base
      op1 = adjust_operator_for_mode(@operand1, @mode1)
      puts "Adding #{op1} to the current shift value, which is #{@shift}" if DEBUG
      @shift += op1
      @i += 2
    when 99 # halt
      @output.halt if @output.respond_to?(:receive_halt)
      @terminated = true
    else
      raise "Unexpected opcode at index #{@i}: #{@opcode}, #{@tape[@i]}"
    end
  end

  def adjust_operator_for_mode(op, mode)
    raise "why is operand nil?" if op.nil?
    case mode
    when POSITION then @tape[op]
    when IMMEDIATE then op
    when RELATIVE then @tape[op + @shift]
    else raise "wtf is #{mode}"
    end
  end

  def adjust_address_operator_for_mode(op, mode)
    raise "why is operand nil?" if op.nil?
    case mode
    when POSITION then op
    when IMMEDIATE then raise "Mode should not be immediate for address operator!"
    when RELATIVE then op + @shift
    else raise "wtf is #{mode}"
    end
  end
end

class Tape < Struct.new(:tape)
  def [](i)
    raise "Can't read from negative number: #{i}" if i < 0
    tape[i] || 0
  end

  def expand_tape(i)
    return if tape[i]
    tape << 0 until tape[i]
  end

  def []=(i, val)
    raise "Can't read from relative number" if i < 0
    expand_tape(i)
    tape[i] = val
  end
end

class Reader < Struct.new(:hardcoded_input)
  def read
    hardcoded_input || gets.chomp.to_i
  end
end

class Writer < Struct.new(:ignore_input)
  def write(x)
    puts x unless x == ignore_input
  end
end
