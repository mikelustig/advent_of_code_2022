#!ruby

signal = File.read('input_l.txt')

start_position = signal.length.times do |i|
  break i if signal[i..i+13].chars.uniq.count == 14
end

puts start_position + 14 # 1-indexed end of the 14-character unique sequence.
