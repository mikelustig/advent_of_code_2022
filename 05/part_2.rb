#!ruby

def parse_ship(ship)
  lines = ship.split("\n").map(&:rstrip)
  cargo_state = {}
  stack_indices = {}
  lines.last.each_char.with_index do |char,i|
    stack_num = char.to_i
    if stack_num > 0
      cargo_state[stack_num] = []
      stack_indices[stack_num] = i
    end
  end

  lines[0..-2].reverse.each do |line|
    cargo_state.each do |stack_num, stack|
      cargo = line[stack_indices[stack_num]]

      stack.push(cargo) if cargo && cargo != ' '
    end
  end

  cargo_state
end

def parse_instruction_set(instruction_set)
  instructions = instruction_set.split("\n").map(&:strip).map do |instruction|
    parts = instruction.split(' ').map(&:to_i)

    { count: parts[1], from: parts[3], to: parts[5] }
  end

  instructions
end

def move(cargo_state, instruction)
  cargo_state[instruction[:to]] += cargo_state[instruction[:from]].pop(instruction[:count])
end

ship,instruction_set = File.read('input_l.txt').split("\n\n")

cargo_state = parse_ship(ship)
instructions = parse_instruction_set(instruction_set)

instructions.each do |instruction|
  move(cargo_state, instruction)
end

puts cargo_state.values.map(&:last).join
