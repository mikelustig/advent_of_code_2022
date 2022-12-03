#!ruby

bags = File.readlines('input_l.txt').map(&:strip).map(&:bytes)

def item_priority(item)
  if item > 90
    item - 96
  else
    item - 38
  end
end

def bag_priority(bag)
  halves = bag.each_slice(bag.size / 2).to_a
  halves[0].intersection(halves[1]).map{ |item| item_priority(item) }.reduce(:+)
end

puts bags.reduce(0) { |priority_sum,bag| priority_sum + bag_priority(bag) }
