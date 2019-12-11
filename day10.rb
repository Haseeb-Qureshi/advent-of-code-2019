require 'set'
BLANK = '.'.freeze
ASTEROID = '#'.freeze

file = File.read("input10.txt").chomp
GRID = file.lines.map(&:chomp).map(&:chars)

puts "Part 1"

def in_grid?(x, y)
  x >= 0 && y >= 0 && GRID[x] && GRID[x][y]
end

def neighbors(x, y)
  [
    [x + 1, y],
    [x - 1, y],
    [x, y + 1],
    [x, y - 1],
  ].select { |nx, ny| in_grid?(nx, ny) }
end

def grid(x, y)
  GRID[x][y]
end

def visible_from(origin_x, origin_y)
  return 0 if GRID[origin_x][origin_y] == BLANK

  queue = [[origin_x, origin_y]]
  visited = Set.new
  blocked = Set.new
  visible = 0

  until queue.empty?
    this_x, this_y = queue.shift

    if GRID[this_x][this_y] == ASTEROID &&
      [this_x, this_y] != [origin_x, origin_y] &&
      !blocked.include?([this_x, this_y])
      # scan out forward each DX, DY until you fall off
      visible += 1
      delta_x = this_x - origin_x
      delta_y = this_y - origin_y
      gcd = delta_x.gcd(delta_y)
      dx = delta_x / gcd
      dy = delta_y / gcd

      cur_x = this_x + dx
      cur_y = this_y + dy

      while in_grid?(cur_x, cur_y)
        blocked << [cur_x, cur_y]
        cur_x += dx
        cur_y += dy
      end
    end

    neighbors(this_x, this_y).each do |nx, ny|
      next if visited.include?([nx, ny])
      visited << [nx, ny]
      queue << [nx, ny]
    end
  end

  visible
end

max = 0
GRID.length.times do |i|
  GRID[0].each_index do |j|
    visible = visible_from(i, j)
    if visible > max
      max = visible
      best = [i, j]
    end
  end
end

puts max
