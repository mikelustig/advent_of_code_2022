#!ruby
require 'json'

def incorrect_order?(pair)
  left = pair[0]
  right = pair[1]

  puts "Checking left: #{left}, right: #{right}"

  if (left.is_a?(Array) && !right.is_a?(Array)) || (!left.is_a?(Array) && right.is_a?(Array))
    return incorrect_order?([Array(left), Array(right)])
  end

  left.each_with_index do |lval, i|
    return true unless right.count > i
    rval = right[i]
    if lval.is_a?(Array) || rval.is_a?(Array)
      subarray_result = incorrect_order?([lval, rval])
      return true if subarray_result
      return false if subarray_result == false # as opposed to nil
    else
      return false if lval < rval
      return true if lval > rval
    end
  end

  return nil if left.count == right.count
  return false
end

packets = File.read('input_l.txt').split("\n").map(&:strip).map { |ary| next nil if ary == ''; JSON.parse(ary) }.compact
packets << [[2]]
packets << [[6]]

sorted = packets.sort do |p1, p2|
  if incorrect_order?([p1, p2])
    1
  else
    -1
  end
end

puts (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
