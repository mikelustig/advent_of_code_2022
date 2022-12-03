#!ruby

bags = File.readlines('input_l.txt').map(&:strip).map(&:bytes)
groups = bags.each_slice(3)

def item_priority(item)
  if item > 90
    item - 96
  else
    item - 38
  end
end

def group_priority(group)
  common_item = group[0].intersection(group[1]).intersection(group[2]).first
  item_priority(common_item)
end

puts groups.reduce(0) { |priority_sum,group| priority_sum + group_priority(group) }
