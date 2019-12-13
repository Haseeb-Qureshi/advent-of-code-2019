require 'set'
require 'pp'
BLANK = '.'.freeze
ASTEROID = '#'.freeze

file = File.read("input10.txt").chomp
GRID = file.lines.map(&:chomp).map(&:chars)

def grid(x, y)
  GRID[x][y]
end

def angle_between(ast1, ast2)
  x1, y1 = ast1
  x2, y2 = ast2
  Math.atan2(y2 - y1, -(x2 - x1)) % (2 * Math::PI)
end

def dist_between(x1, y1, x2, y2)
  Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
end

def print_grid(grid = GRID)
  grid.map { |row| row.map { |i| i.to_s.rjust(3, " ") }.join }
end

puts "Part 1"

asteroids = []
GRID.each_index do |i|
  GRID[0].each_index do |j|
    next unless grid(i, j) == ASTEROID

    asteroids << [i, j]
  end
end

best, best_visible = asteroids.map do |ast|
  [ast, asteroids.group_by { |ast2| angle_between(ast, ast2) }.keys.count]
end.max_by(&:last)

puts best_visible

puts "Part 2"

asteroids.delete(best)

spans = asteroids.group_by { |ast| angle_between(best, ast) }

asteroids_behind_asteroid_in_line = asteroids.map do |ast|
  angle = angle_between(best, ast)
  spans[angle].length - spans[angle].index(ast)
end

final_asteroids = asteroids.sort_by.with_index do |ast, i|
  [
    asteroids_behind_asteroid_in_line[i],
    angle_between(best, ast)
  ]
end

final_asteroids.each_with_index do |ast, i|
  GRID[ast[0]][ast[1]] = i
end

asteroid_200 = final_asteroids[199]
puts asteroid_200[1] * 100 + asteroid_200[0]
