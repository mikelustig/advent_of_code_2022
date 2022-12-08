#!ruby

class TreeField
  def initialize(input)
    @field = {}
    @max_x = 0
    @max_y = 0

    File.readlines(input).map { |line| line.strip.split('') }.each_with_index do |row, y|
      @max_y = [@max_y, y].max
      row.each_with_index do |cell, x|
        @field[[x, y]] = { height: cell.to_i, visible: false, scenic_score: 0 }
        @max_x = [@max_x, x].max
      end
    end

    calculate_scenic_scores
    visualize_field
  end

  def max_scenic_score
    @field.values.max { |tree_1, tree_2| tree_1[:scenic_score] <=> tree_2[:scenic_score] }
  end

  private

  def calculate_scenic_scores
    (1..@max_x - 1).each do |x|
      (1..@max_y - 1).each do |y|
        @field[[x, y]][:scenic_score] = calculate_scenic_score(x, y)
      end
    end
  end

  def calculate_scenic_score(x, y)
    height = @field[[x, y]][:height]
    viewing_distance_left(x, y, height) *
      viewing_distance_right(x, y, height) *
      viewing_distance_down(x, y, height) *
      viewing_distance_up(x, y, height)
  end

  def viewing_distance_left(x, y, height)
    viewing_distance = 0
    (0..(x-1)).to_a.reverse.each do |z|
      viewing_distance += 1
      break if height <= @field[[z, y]][:height]
    end
    viewing_distance
  end

  def viewing_distance_right(x, y, height)
    viewing_distance = 0
    ((x+1)..@max_x).each do |z|
      viewing_distance += 1
      break if height <= @field[[z, y]][:height]
    end
    viewing_distance
  end

  def viewing_distance_down(x, y, height)
    viewing_distance = 0
    (0..(y-1)).to_a.reverse.each do |z|
      viewing_distance += 1
      break if height <= @field[[x, z]][:height]
    end
    viewing_distance
  end

  def viewing_distance_up(x, y, height)
    viewing_distance = 0
    ((y+1)..@max_y).each do |z|
      viewing_distance += 1
      break if height <= @field[[x, z]][:height]
    end
    viewing_distance
  end

  def visualize_field
    (0..@max_x).each do |x|
      (0..@max_y).each do |y|
        print "#{@field[[x, y]][:scenic_score]}\t"
      end
      print "\n"
    end
  end
end

puts TreeField.new('input_l.txt').max_scenic_score
