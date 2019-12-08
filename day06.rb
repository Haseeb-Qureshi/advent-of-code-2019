# What is the total number of direct and indirect orbits in your map data?
require 'set'

input = File.read("input06.txt")
pairs = input.lines.map(&:chomp).map { |line| line.split(")") }

all_stars = Set.new
orbiters = Hash.new { |h, k| h[k] = Set.new }
num_orbiters = {}

pairs.each do |star, orbiter|
  orbiters[star] << orbiter
  all_stars << star << orbiter
end

def total_orbits(orbiter, orbiters, num_orbiters)
  return num_orbiters[orbiter] if num_orbiters[orbiter]

  total = orbiters[orbiter].sum do |star|
    1 + total_orbits(star, orbiters, num_orbiters)
  end

  num_orbiters[orbiter] = total
end

puts all_stars.sum { |star| total_orbits(star, orbiters, num_orbiters) }
