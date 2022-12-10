#!ruby

require 'matrix'
require 'set'

head_motions = File.readlines('input_l.txt').map(&:strip).map { |line| line.split(' ') }.map { |pair| { direction: pair[0], steps: pair[1].to_i } }

head_position = Matrix[[0, 0]]
tail_position = Matrix[[0, 0]]
positions_visited = Set[tail_position.to_a.flatten]

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
    head_position += head_change

    position_diff = head_position - tail_position
    tail_change = case position_diff
    when Matrix[[0,2]]
      Matrix[[0,1]]
    when Matrix[[1,2]], Matrix[[2,1]]
      Matrix[[1,1]]
    when Matrix[[2,0]]
      Matrix[[1,0]]
    when Matrix[[1,-2]], Matrix[[2,-1]]
      Matrix[[1,-1]]
    when Matrix[[0,-2]]
      Matrix[[0,-1]]
    when Matrix[[-1,-2]], Matrix[[-2,-1]]
      Matrix[[-1,-1]]
    when Matrix[[-2,0]]
      Matrix[[-1,0]]
    when Matrix[[-2,1]], Matrix[[-1,2]]
      Matrix[[-1,1]]
    end

    if tail_change
      tail_position += tail_change
      positions_visited << tail_position.to_a.flatten
    end
  end
end

puts positions_visited.count
