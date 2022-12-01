#!ruby

input = File.read('input_l.txt')

puts input.split("\n\n").map { |chunk| chunk.split("\n").map(&:to_i) }.map(&:sum).max
