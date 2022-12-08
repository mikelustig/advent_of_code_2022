#!ruby

class TreeField
  def initialize(input)
    @field = {}
    @max_x = 0
    @max_y = 0

    File.readlines(input).map { |line| line.strip.split('') }.each_with_index do |row, y|
      @max_y = [@max_y, y].max
      row.each_with_index do |cell, x|
        @field[[x, y]] = { height: cell.to_i, visible: false }
        @max_x = [@max_x, x].max
      end
    end

    mark_visible_trees_from_left
    mark_visible_trees_from_right
    mark_visible_trees_from_top
    mark_visible_trees_from_bottom
    visualize_field
  end

  def visible_trees
    @field.values.count { |tree| tree[:visible] == true }
  end

  private

  def visualize_field
    (0..@max_x).each do |x|
      (0..@max_y).each do |y|
        print "#{@field[[x, y]][:visible]}\t"
      end
      print "\n"
    end
  end

  def mark_visible_trees_h(rng)
    (0..@max_y).each do |y|
      max_height = -1
      rng.each do |x|
        tree_height = @field[[x, y]][:height]
        if tree_height > max_height
          @field[[x, y]][:visible] = true
          max_height = tree_height
        end
      end
    end
  end

  def mark_visible_trees_v(rng)
    (0..@max_x).each do |x|
      max_height = -1
      rng.each do |y|
        tree_height = @field[[x, y]][:height]
        if tree_height > max_height
          @field[[x, y]][:visible] = true
          max_height = tree_height
        end
      end
    end
  end

  def mark_visible_trees_from_left
    mark_visible_trees_h((0..@max_x))
  end

  def mark_visible_trees_from_right
    mark_visible_trees_h((0..@max_x).to_a.reverse)
  end

  def mark_visible_trees_from_top
    mark_visible_trees_v((0..@max_y))
  end

  def mark_visible_trees_from_bottom
    mark_visible_trees_v((0..@max_y).to_a.reverse)
  end
end

puts TreeField.new('input_l.txt').visible_trees
