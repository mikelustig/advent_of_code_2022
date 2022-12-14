#!ruby

class Monkey
  attr_reader :inspections, :test_val
  attr_writer :lcm

  def initialize(items:, operation:, test_val:, true_action:, false_action:, monkeys:)
    @items = items
    @operation = operation
    @test_val = test_val
    @true_action = true_action
    @false_action = false_action
    @monkeys = monkeys
    @inspections = 0
  end

  def take_turn
    @items.each do |item|
      process_item(item)
    end

    @items.clear
  end

  def transfer_item(item)
    @items.push(item)
  end

  def print_self
    puts "Items: #{@items.inspect}"
    puts "Inspections: #{@inspections}"
  end

  private

  def process_item(item)
    @inspections += 1
    lhs = item
    if @operation[:rhs] == 'old'
      rhs = item
    else
      rhs = @operation[:rhs].to_i
    end

    new_val = case @operation[:op]
    when '+'
      lhs + rhs
    when '*'
      (lhs * rhs) % @lcm
    end

    result = (new_val % @test_val) == 0

    target_monkey = result ?  @true_action : @false_action

    @monkeys[target_monkey].transfer_item(new_val)
  end
end

def parse_operation(op_line)
  parts = op_line.split('=')[1].strip.split(' ')

  { lhs: parts[0], op: parts[1], rhs: parts[2] }
end

def parse_monkey(monkeys, monkey_chunk)
  lines = monkey_chunk.split("\n")
  index = lines[0][/\d+/].to_i
  items = lines[1].scan(/\d+/).map(&:to_i)
  operation = parse_operation(lines[2])
  test_val = lines[3][/\d+/].to_i
  true_action = lines[4][/\d+/].to_i
  false_action = lines[5][/\d+/].to_i

  monkeys[index] = Monkey.new(items: items, operation: operation, test_val: test_val, true_action: true_action, false_action: false_action, monkeys: monkeys)
end

monkeys = {}
File.read('input_l.txt').split("\n\n").each { |chunk| parse_monkey(monkeys, chunk) } # I desparately want to make a variable named 'chunky_monkey'

lcm = monkeys.values.reduce(1) { |prod, monkey| prod * monkey.test_val }

monkeys.values.each { |monkey| monkey.lcm = lcm }

monkey_order = monkeys.keys().sort
10000.times do |round|
  monkey_order.each do |index|
    monkeys[index].take_turn
  end
end

puts monkeys.values.map(&:inspections)
puts monkeys.values.map(&:inspections).max(2).reduce(:*)
