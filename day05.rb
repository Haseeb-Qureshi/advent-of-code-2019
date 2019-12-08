require_relative 'utils/utils'

puts "Part 1"
input = File.read('input05.txt').chomp.split(',').map(&:to_i).freeze
IntcodeComputer.run_program(input, Reader.new(1), Writer.new(0))

puts "Part 2"
file = File.read('input05.txt')
input = file.chomp.split(',').map(&:to_i).freeze
IntcodeComputer.run_program(input, Reader.new(5), Writer.new(0))
