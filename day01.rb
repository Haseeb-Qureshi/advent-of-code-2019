masses = File.readlines('input01.txt').map(&:chomp).map(&:to_i)

# At the first Go / No Go poll, every Elf is Go until the Fuel Counter-Upper. They haven't determined the amount of fuel required yet.
#
# Fuel required to launch a given module is based on its mass. Specifically, to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.
#
# For example:
#
# For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
# For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
# For a mass of 1969, the fuel required is 654.
# For a mass of 100756, the fuel required is 33583.
# The Fuel Counter-Upper needs to know the total fuel requirement. To find it, individually calculate the fuel needed for the mass of each module (your puzzle input), then add together all the fuel values.

def fuel(mass)
  [mass / 3 - 2, 0].max
end

puts "Part 1: ", masses.sum { |mass| fuel(mass) }

##### PART 2 #####

# So, for each module mass, calculate its fuel and add it to the total. Then, treat the fuel amount you just calculated as the input mass and repeat the process, continuing until a fuel requirement is zero or negative. For example:

FUEL_COSTS = {}

def total_fuel_cost(mass)
  return 0 if mass == 0
  return FUEL_COSTS[mass] if FUEL_COSTS[mass]

  FUEL_COSTS[mass] = fuel(mass) + total_fuel_cost(fuel(mass))
end

puts "Part 2: ", masses.sum { |mass| total_fuel_cost(mass) }
