file = "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

file.lines.map do |line|
  inputs, outputs = map.split(" => ")
  num, output = outputs.split
  inputs.split(',').map do |s|
    input_num, input = s.split
    [input_num.to_i, input]
  end
  [[num.to_i, output], ]
end
