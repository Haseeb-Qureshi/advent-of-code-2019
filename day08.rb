puts "Part 1"

WIDTH = 25
HEIGHT = 6
input = File.read('input08.txt').chars.map(&:to_i)

layers = input.each_slice(WIDTH * HEIGHT)
min_layer = layers.min_by { |slice| slice.count(0) }
puts min_layer.count(1) * min_layer.count(2)

puts "Part 2"

# 0 is black, 1 is white, and 2 is transparent.
BLACK = 0
WHITE = 1
TRANSPARENT = 2

def stack_pixel(cur, new)
  case new
  when BLACK then BLACK
  when WHITE then WHITE
  when TRANSPARENT then cur
  else raise "wtf"
  end
end

first_layer, *remaining_layers = input.each_slice(WIDTH * HEIGHT).to_a.reverse
each_pixel_by_layers = first_layer.zip(*remaining_layers)

each_pixel = each_pixel_by_layers.map do |layer|
  layer.reduce { |cur, new| stack_pixel(cur, new) }
end

each_pixel.each_slice(WIDTH) do |row|
  puts row.join.gsub('0', '■').gsub('1', '□')
end
