puts "Part 1"

INPUTS = (153517..630395)

def is_valid?(num)
  digits = num.digits
  digits.each_cons(2).all? { |a, b| a >= b } &&
    digits.each_cons(2).any? { |pair| pair.reduce(:eql?) }
end

puts INPUTS.count { |num| is_valid?(num) }

puts "Part 2"

def is_valid_part_2?(num)
  digits = num.digits
  digits.each_cons(2).all? { |a, b| a >= b } &&
    digits.group_by(&:itself).any? { |h, k| k.length == 2 }
end

puts INPUTS.count { |num| is_valid_part_2?(num) }
