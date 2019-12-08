masses = File.readlines('input01.txt').map(&:chomp).map(&:to_i)

def fuel(mass)
  [mass / 3 - 2, 0].max
end

puts "Part 1: ", masses.sum { |mass| fuel(mass) }

FUEL_COSTS = {}

def total_fuel_cost(mass)
  return 0 if mass == 0
  return FUEL_COSTS[mass] if FUEL_COSTS[mass]

  FUEL_COSTS[mass] = fuel(mass) + total_fuel_cost(fuel(mass))
end

puts "Part 2: ", masses.sum { |mass| total_fuel_cost(mass) }
