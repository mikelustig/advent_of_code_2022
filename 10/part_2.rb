#!ruby

class MCP
  attr_reader :total

  def initialize
    @program = File.readlines('input_l.txt').map(&:strip).map { |line| line.split(' ') }
    @clock = 1
    @x = 1
    @screen = {}
  end

  def tick # tock, on the clock
    x_val = (@clock % 40)
    y_val = @clock / 40

    pixel = '.'
    pixel = '#' if [-1,0,1].include?(x_val - @x)

    @screen[[x_val, y_val]] = pixel
    @clock += 1
  end

  def run_program
    @program.each do |command|
      case command[0]
      when 'addx'
        tick
        @x += command[1].to_i
        tick
      when 'noop'
        tick
      end
    end
  end

  def draw
    (0..5).each do |y|
      (0..40).each do |x|
        print @screen[[x,y]]
      end
      puts ''
    end
  end
end

mcp = MCP.new
mcp.run_program
mcp.draw
