require 'set'

MAZE = "#########
#b.A.@.a#
#########".lines.map(&:chars)

ENTRANCE = '@'.freeze
WALL = '#'.freeze
OPEN = '.'.freeze

def key?(c)
  c.downcase == c && alpha?(c)
end

def alpha?(c)
  c.swapcase != c
end

def door?(c)
  !key?(c) && alpha?(c)
end

def initialize_maze
  MAZE.each_index do |i|
    MAZE[0].each_index do |j|
      next unless MAZE[i][j] == ENTRANCE
      MAZE[i][j] = OPEN
      return [i, j]
    end
  end
end

def neighbors(pos)
  x, y = pos
  [
    x - 1, y,
    x + 1, y,
    x, y + 1,
    x, y - 1
  ].select do |i, j|
    i.between?(0, MAZE.length - 1) && j.between?(0, MAZE[0].length - 1)
  end
end

def traversable?(pos, keyset)

end

pos = initialize_maze

num_keys = MAZE.sum { |row| row.count { |c| key?(c) } }

def bfs(start, end_cond)
  best_distances = {}
  queue = [start, 0, Set.new] # position, total distance, collected_keys

  until queue.empty?
    pos, dist, collected_keys = queue.shift
    next if seen[]

  end
end
