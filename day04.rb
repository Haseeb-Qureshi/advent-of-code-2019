# However, they do remember a few key facts about the password:

# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
#
# How many different passwords within the range given in your puzzle input meet these criteria?

puts "Part 1"

INPUTS = (153517..630395)

def is_valid?(num)
  digits = num.digits
  digits.each_cons(2).all? { |a, b| a >= b } &&
    digits.each_cons(2).any? { |pair| pair.reduce(:eql?) }
end

puts INPUTS.count { |num| is_valid?(num) }

puts "Part 2"

# The two adjacent matching digits are not part of a larger group of matching digits.
#
# Given this additional criterion, but still ignoring the range rule, the following are now true:
#
# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
# How many different passwords within the range given in your puzzle input meet all of the criteria?

def is_valid_part_2?(num)
  digits = num.digits
  digits.each_cons(2).all? { |a, b| a >= b } &&
    digits.group_by(&:itself).any? { |h, k| k.length == 2 }
end

puts INPUTS.count { |num| is_valid_part_2?(num) }
