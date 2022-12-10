#!ruby

require 'matrix'
require 'set'

def print_board(knots)
  x_min = knots.min { |knot_1, knot_2| knot_1[0,0] <=> knot_2[0,0] }[0,0]
  y_min = knots.min { |knot_1, knot_2| knot_1[0,1] <=> knot_2[0,1] }[0,1]
  x_max = knots.max { |knot_1, knot_2| knot_1[0,0] <=> knot_2[0,0] }[0,0]
  y_max = knots.max { |knot_1, knot_2| knot_1[0,1] <=> knot_2[0,1] }[0,1]

  puts 'board'
  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      char = '*'
      knots.each_with_index do |knot,i|
        if knot[0,0] == x && knot[0,1] == y
          char = i
        end
      end
      print char
    end
    puts ''
  end
end

head_motions = File.readlines('input_l.txt').map(&:strip).map { |line| line.split(' ') }.map { |pair| { direction: pair[0], steps: pair[1].to_i } }

NUM_KNOTS = 10.freeze
knots = NUM_KNOTS.times.map { Matrix[[0, 0]] }
positions_visited = Set[knots.last.to_a.flatten]

head_motions.each do |motion|
  head_change = case motion[:direction]
  when 'R'
    Matrix[[1,0]]
  when 'L'
    Matrix[[-1,0]]
  when 'D'
    Matrix[[0,1]]
  when 'U'
    Matrix[[0,-1]]
  end

  motion[:steps].times do
    knots[0] += head_change

    NUM_KNOTS.times do |leader_num|
      follower_num = leader_num + 1

      position_diff = knots[leader_num] - knots[follower_num]
      follower_change = case position_diff
      when Matrix[[0,2]]
        Matrix[[0,1]]
      when Matrix[[1,2]], Matrix[[2,1]], Matrix[[2,2]]
        Matrix[[1,1]]
      when Matrix[[2,0]]
        Matrix[[1,0]]
      when Matrix[[1,-2]], Matrix[[2,-1]], Matrix[[2,-2]]
        Matrix[[1,-1]]
      when Matrix[[0,-2]]
        Matrix[[0,-1]]
      when Matrix[[-1,-2]], Matrix[[-2,-1]], Matrix[[-2,-2]]
        Matrix[[-1,-1]]
      when Matrix[[-2,0]]
        Matrix[[-1,0]]
      when Matrix[[-2,1]], Matrix[[-1,2]], Matrix[[-2,2]]
        Matrix[[-1,1]]
      end

      if follower_change
        knots[follower_num] += follower_change
        if leader_num == NUM_KNOTS - 2
          positions_visited << knots[follower_num].to_a.flatten
        end
      end

      #print_board(knots)
      break if leader_num == NUM_KNOTS - 2
    end
  end
end

puts positions_visited.count
