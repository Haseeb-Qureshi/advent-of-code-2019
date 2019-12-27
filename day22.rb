class Deck
  attr_reader :stack
  def initialize(size: 10)
    @stack = *(0...size)
  end

  def new_stack
    @stack.reverse!
  end

  def cut(n)
    @stack.rotate!(n)
  end

  def increment(n)
    new_order = (0..Float::INFINITY).step(n).first(length).map { |i| i % length }
    new_stack = Array.new(length)
    new_order.each_with_index { |new_idx, i| new_stack[new_idx] = @stack[i] }
    @stack = new_stack
  end

  private

  def length
    @stack.length
  end
end

puts "Part 1"

raw_instructions = File.readlines("input22.txt").map(&:chomp)

deck = Deck.new(size: 10_007)
increments = []
cuts = []
flip = false

raw_instructions.each do |instr|
  case instr
  when /increment/
    increments << instr.split.last.to_i
    deck.increment(increments.last)
  when /cut/
    cuts << instr.split.last.to_i
    deck.cut(cuts.last)
  when /new stack/
    flip = !flip
    deck.new_stack
  else
    raise "wtf is #{instr}"
  end
end


# increments.each { |n| deck.increment(n) }
# cuts.each { |n| deck.cut(n) }
# deck.new_stack unless flip

puts deck.stack.index(2019)

puts "Part 2"

p cuts.sum
p cuts
p increments
deck_size = 119315717514047
times_to_shuffle = 101741582076661
