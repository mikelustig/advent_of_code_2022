#!ruby

signal = File.read('input_l.txt')

start_position = signal.length.times do |i|
  break i if signal[i..i+3].chars.uniq.count == 4
end

puts start_position + 4 # 1-indexed end of the 4-character unique sequence.
