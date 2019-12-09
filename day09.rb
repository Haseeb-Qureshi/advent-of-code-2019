require_relative 'utils/utils'
require 'pry-nav'

puts "Part 1"
file = File.read("input09.txt")
tape = file.chomp.split(",").map(&:to_i)
IntcodeComputer.run_program(tape, Reader.new(1))

puts "Part 2"
IntcodeComputer.run_program(tape, Reader.new(2))
