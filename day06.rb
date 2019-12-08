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

puts "Part 1"
puts all_stars.sum { |star| total_orbits(star, orbiters, num_orbiters) }


puts "Part 2"
# What is the minimum number of orbital transfers required to move from the object YOU are orbiting to the object SAN is orbiting? (Between the objects they are orbiting - not between YOU and SAN.)

# Graph search between YOU and orbitee of SAN
origin = 'YOU'
target = orbiters.keys.find { |star| orbiters[star].include?('SAN') }

connections = orbiters # Just go ahead and fuck this shit up
connections.each do |star, orbiters_of_star|
  orbiters_of_star.each { |orbiter| connections[orbiter] << star }
end

def bfs(source, target, graph)
  queue = [[source, 0]]
  visited = Set.new([source])

  until queue.empty?
    node, dist = queue.shift
    return dist if node == target

    graph[node].each do |neighbor|
      next if visited.include?(neighbor)
      visited << neighbor
      queue << [neighbor, dist + 1]
    end
  end

  raise "Couldn't find it!"
end

p bfs(origin, target, connections) - 1
