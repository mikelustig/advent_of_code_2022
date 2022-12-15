#!ruby

board = {}
max_x = 0
max_y = 0
start_x = 0
start_y = 0
end_x = 0
end_y = 0

File.readlines('input_l.txt').map(&:strip).each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    if cell == 'S'
      start_x = x
      start_y = y
      cell_override = 1
    elsif cell == 'E'
      end_x = x
      end_y = y
      cell_override = 26
    end
    board[[x,y]] = cell_override || cell.bytes.first - 96
    max_x = x if x > max_x
  end
  max_y = y if y > max_y
end

def print_board(max_x, max_y, board)
  (max_y +1 ).times do |y|
    (max_x + 1).times do |x|
      print (board[[x,y]]+96).chr
    end
    puts ''
  end
end

# print_board(max_x, max_y, board)

def out_of_bounds?(position, max_x, max_y)
  position[0] < 0 || position[0] > max_x || position[1] < 0 || position[1] > max_y
end

paths = []
(max_y + 1).times do |y|
  (max_x + 1).times do |x|
    paths << [[x,y]] if board[[x,y]] == 1
  end
end

visits = [[start_x,start_y]]

path_found = false
path_length = 0
while(!path_found) do
  new_paths = []
  paths_to_delete = []
  paths.each do |path|
    head = path.last
    branching = false
    dead_end = true
    curr_path = path.dup
    [[1,0], [0,1], [-1,0], [0,-1]].each do |direction|
      new_head = [head[0] + direction[0], head[1] + direction[1]]
      next if out_of_bounds?(new_head, max_x, max_y)
      next if board[new_head] - board[head] > 1
      next if visits.include?(new_head)

      visits << new_head
      dead_end = false
      path_found ||= new_head[0] == end_x && new_head[1] == end_y

      if branching
        new_path = curr_path.dup
        new_path << new_head
        new_paths << new_path
      else
        branching = true
        path << new_head
      end
    end
    paths_to_delete << path if dead_end
  end
  paths -= paths_to_delete
  paths += new_paths
  path_length += 1
end

puts path_length
