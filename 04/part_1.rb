#!ruby

raw_range_pairs = File.readlines('input_l.txt').map(&:strip).map { |line| line.split(',') }

range_pairs = raw_range_pairs.map do |range_pair|
  range_pair.map { |range| range.split('-').map(&:to_i) }.map { |stops| Range.new(stops[0], stops[1]) }
end

overlap = range_pairs.reduce(0) do |count, range_pair|
  if range_pair[0].cover?(range_pair[1]) || range_pair[1].cover?(range_pair[0])
    count + 1
  else
    count
  end
end

puts overlap
