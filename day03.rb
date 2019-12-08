# These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.

# R75,D30,R83,U83,L12,D49,R71,U7,L72
# U62,R66,U55,R34,D71,R55,D58,R83 = distance 159

puts "Part 1: "
inputs = File.readlines("input03.txt").map(&:chomp)
wire1 = inputs.first.split(',')
wire2 = inputs.last.split(',')

Point = Struct.new(:x, :y)
Line = Struct.new(:start, :end, :steps_so_far)

def collect_lines(wire)
  x = 0
  y = 0
  lines = []

  steps_so_far = 0
  wire.map do |input|
    dir, distance = input[0], Integer(input[1..-1])
    starting_point = Point.new(x, y)

    steps_so_far += distance
    case dir
    when 'R'
      x += distance
    when 'L'
      x -= distance
    when 'D'
      y -= distance
    when 'U'
      y += distance
    else
      raise 'wtf is ' + dir
    end

    ending_point = Point.new(x, y)
    Line.new(starting_point, ending_point, steps_so_far)
  end
end

wire1_lines = collect_lines(wire1)
wire2_lines = collect_lines(wire2)

def intersect?(line1, line2)
  if vertical?(line1)
    if vertical?(line2) # both lines are vertical
      return false unless line1.start.x == line2.start.x
      touch?(line1.start.y..line1.end.y, line2.start.y..line2.end.y)
    else # line1 is vertical, line2 is horizontal
      cross?(line2, line1)
    end
  else
    if vertical?(line2) # line1 is horizontal, line 2 is vertical
      cross?(line1, line2)
    else # both lines are horizontal
      return false unless line1.start.y == line2.start.y
      touch?(line1.start.x..line1.end.x, line2.start.x..line2.end.x)
    end
  end
end

def clean(range)
  range.begin <= range.end ? range : (range.end..range.begin)
end

def vertical?(line)
  line.start.x == line.end.x
end

def horizontal?(line)
  !vertical?(line)
end

def touch?(range1, range2)
  range1 = clean(range1)
  range2 = clean(range2)
  range1.include?(range2.begin) || range1.include?(range2.end) || range2.cover?(range1)
end

def cross?(horiz, vert)
  clean(horiz.start.x..horiz.end.x).include?(vert.start.x) &&
    clean(vert.start.y..vert.end.y).include?(horiz.start.y)
end

def find_intersection_point(line1, line2)
  if vertical?(line1) && vertical?(line2)
    intersection_point_between_parallel(line1, line2)
  elsif vertical?(line1) && horizontal?(line2)
    intersection_point_between_horizontal_and_vertical(line2, line1)
  elsif horizontal?(line1) && vertical?(line2)
    intersection_point_between_horizontal_and_vertical(line1, line2)
  elsif horizontal?(line1) && horizontal?(line2)
    intersection_point_between_parallel(line1, line2)
  else
    raise "wtf wtf"
  end
end

def intersection_point_between_parallel(line1, line2)
  if vertical?(line1) && vertical?(line2)
    range1 = clean(line1.start.y..line1.end.y)
    range2 = clean(line2.start.y..line2.end.y)
  elsif horizontal?(line1) && horizontal?(line2)
    range1 = clean(line1.start.x..line1.end.x)
    range2 = clean(line2.start.x..line2.end.x)
  else
    raise "omg wtf"
  end
  return line1.end if range1.end == range2.begin
  return line1.start if range1.begin == range2.end
  return line2.start if range1.include?(range2.begin)
  return line2.end if range1.include?(range2.end)
  return line1.start if range2.cover?(range1)
  raise "omg how did I get here"
end

def intersection_point_between_horizontal_and_vertical(horiz, vert)
  Point.new(vert.start.x, horiz.start.y)
end

def manhattan_distance(point)
  manhattan_distance_between(point, Point.new(0, 0))
end

def manhattan_distance_between(point1, point2)
  (point2.x - point1.x).abs + (point2.y - point1.y).abs
end

points = []
wire1_lines.each_with_index do |line1, i|
  wire2_lines.each_with_index do |line2, j|
    if intersect?(line1, line2)
      point = find_intersection_point(line1, line2)
      next if point.x.zero? && point.y.zero?
      points << point
    end
  end
end

points.reject! { |point| point.x.zero? && point.y.zero? }

p points.map { |point| manhattan_distance(point) }.min

## Part 2 ##

points_with_distances = []
wire1_lines.each_with_index do |line1, i|
  wire2_lines.each_with_index do |line2, j|
    if intersect?(line1, line2)
      point = find_intersection_point(line1, line2)
      dist1 = line1.steps_so_far - manhattan_distance_between(point, line1.end)
      dist2 = line2.steps_so_far - manhattan_distance_between(point, line2.end)
      next if point.x.zero? && point.y.zero?
      # p [dist1, dist2]
      # p [line1, line2]
      # p point
      points_with_distances << [point, dist1 + dist2]
    end
  end
end

p points_with_distances.min_by(&:last)
