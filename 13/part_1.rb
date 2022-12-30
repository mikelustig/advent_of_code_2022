#!ruby
require 'json'

def incorrect_order?(pair)
  left = pair[0]
  right = pair[1]

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

pairs = []
File.read('input_l.txt').split("\n\n") do |pair|
  packets = pair.split("\n").map(&:strip).map { |ary| JSON.parse(ary) }
  pairs << packets
end

sum_of_indices = 0
pairs.each_with_index do |pair, i|
  sum_of_indices += (i + 1) unless incorrect_order?(pair)
end

puts sum_of_indices
