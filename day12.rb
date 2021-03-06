require 'set'
require 'digest'
puts "Part 1"

class Moon
  attr_accessor :x, :y, :z, :dx, :dy, :dz
  def initialize(x, y, z)
    @x, @y, @z = x, y, z
    @dx, @dy, @dz = 0, 0, 0
  end

  def to_s
    "pos=<x=#{@x.to_s.rjust(2)}, y=#{@y.to_s.rjust(2)}, z=#{@z.to_s.rjust(2)}>, vel=<x=#{@dx.to_s.rjust(2)}, y=#{@dy.to_s.rjust(2)}, z=#{@dz.to_s.rjust(2)}>"
  end

  def inspect
    to_s
  end

  def h
    [x, y, z, dx, dy, dz].join(',')
  end

  def kinetic_energy
    [dx, dy, dz].map(&:abs).sum
  end

  def potential_energy
    [x, y, z].map(&:abs).sum
  end

  def total_energy
    kinetic_energy * potential_energy
  end
end

def step(moons)
  apply_gravity(moons)
  apply_velocities(moons)
end

def apply_gravity(moons)
  moons.combination(2).each do |a, b|
    case a.x <=> b.x
    when -1
      a.dx += 1
      b.dx -= 1
    when 1
      a.dx -= 1
      b.dx += 1
    end

    case a.y <=> b.y
    when -1
      a.dy += 1
      b.dy -= 1
    when 1
      a.dy -= 1
      b.dy += 1
    end

    case a.z <=> b.z
    when -1
      a.dz += 1
      b.dz -= 1
    when 1
      a.dz -= 1
      b.dz += 1
    end
  end
end

def apply_velocities(moons)
  moons.each do |moon|
    moon.x += moon.dx
    moon.y += moon.dy
    moon.z += moon.dz
  end
end

file = File.read("input12.txt").chomp
moons = file.lines.map(&:chomp).map do |line|
  Moon.new(*line.scan(/[xyz]=(-?\d+)/).flatten.map(&:to_i))
end

1000.times do |i|
  step(moons)
end

puts moons.sum(&:total_energy)

puts "Part 2"

def find_cycle_length(dim, moons)
  previous_states = Set.new
  i = 0
  loop do
    state = moons.map(&dim).join + moons.map(&('d' + dim.to_s).to_sym).join

    return i if previous_states.include?(state)

    previous_states << state
    i += 1
    step(moons)
  end
end

cycle_lengths = [:x, :y, :z].map do |dim|
  moons = file.lines.map(&:chomp).map do |line|
    Moon.new(*line.scan(/[xyz]=(-?\d+)/).flatten.map(&:to_i))
  end

  find_cycle_length(dim, moons)
end

puts cycle_lengths.reduce(:lcm)
