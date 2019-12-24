PATTERN = [0, 1, 0, -1]
CACHE = {}

puts "Part 1"

def read(n, repeats = 1)
  return CACHE[[n, repeats]] if CACHE[[n, repeats]]

  pattern = PATTERN.cycle
  arr = []
  until arr.length >= n + 1
    arr.concat([pattern.next] * repeats)
  end
  CACHE[[n, repeats]] = arr[1..n]
end

def fft(input)
  input.map.with_index do |_, i|
    pattern = read(input.length, i + 1)
    input.zip(pattern).map { |a, b| a * b }.sum.abs % 10
  end
end

def fft_loop(input, n)
  input = input.digits.reverse
  n.times { input = fft(input) }
  input.join
end

INPUT = 59758034323742284979562302567188059299994912382665665642838883745982029056376663436508823581366924333715600017551568562558429576180672045533950505975691099771937719816036746551442321193912312169741318691856211013074397344457854784758130321667776862471401531789634126843370279186945621597012426944937230330233464053506510141241904155782847336539673866875764558260690223994721394144728780319578298145328345914839568238002359693873874318334948461885586664697152894541318898569630928429305464745641599948619110150923544454316910363268172732923554361048379061622935009089396894630658539536284162963303290768551107950942989042863293547237058600513191659935

# puts fft_loop(INPUT, 100)[0...8]

puts "Part 2"
ANSWER = 30379585

def fft2(input)
  input.map.with_index do |_, i|
    pattern = read(input.length, i + 1)
    input.zip(pattern).map { |a, b| a * b * 10_000 }.sum.abs % 10
  end
end

def fft2_loop(input, n)
  if input.is_a?(String)
    input = input.chars.map(&:to_i)
  else
    input = input.digits.reverse
  end
  offset = input.first(7).join.to_i
  puts offset
  n.times { input = fft(input) }
  input.join
end

puts fft2_loop("03036732577212944063491565474664", 100)
