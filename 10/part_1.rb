#!ruby

class MCP
  attr_reader :total

  def initialize
    @program = File.readlines('input_l.txt').map(&:strip).map { |line| line.split(' ') }
    @clock = 1
    @x = 1
    @total = 0
  end

  def tick # tock, on the clock
    @clock += 1
    if [20, 60, 100, 140, 180, 220].include?(@clock)
      @total += @clock * @x
    end
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
end

mcp = MCP.new
mcp.run_program
puts mcp.total
