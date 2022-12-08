#!ruby

stream = File.readlines('input_l.txt').map(&:strip)

TOTAL_SPACE = 70000000.freeze
SPACE_REQUIRED = 30000000.freeze

commands = []
output_buffer = []

stream.each do |line|
  if line.start_with?('$')
    commands << { op: line.split(' ')[1..-1] }
    commands[-2][:output] = output_buffer.dup unless output_buffer.empty?
    output_buffer = []
  else
    output_buffer << line
  end
end

commands[-1][:output] = output_buffer unless output_buffer.empty?

dir_stack = []
filesystem = {}

commands.each do |cmd|
  op = cmd[:op]
  case op[0]
  when 'cd'
    case op[1]
    when '/'
      dir_stack = ['/']
    when '..'
      dir_stack.pop
    else
      dir_stack.push(op[1])
    end
  when 'ls'
    curr_dir = dir_stack.join('/')
    filesystem[curr_dir] = { files: [], dirs: [] } unless filesystem.key?(curr_dir)
    cmd[:output].each do |line|
      parts = line.split(' ')
      if parts[0] == 'dir'
        filesystem[curr_dir][:dirs] << curr_dir + '/' + parts[1]
      else
        filesize = parts[0].to_i
        filename = parts[1]
        filesystem[curr_dir][:files] << { name: filename, size: filesize }
      end
    end
  end
end

def dir_size(filesystem, dir_name)
  contents = filesystem[dir_name]
  return filesystem[dir_name][:size] if filesystem[dir_name][:size]

  file_total = contents[:files].reduce(0) { |file_total,file| file_total + file[:size] }
  dir_total = contents[:dirs].reduce(0) { |dir_total, dir| dir_total + dir_size(filesystem, dir) }

  filesystem[dir_name][:size] = file_total + dir_total
end

dir_size(filesystem, '/')

free_space = TOTAL_SPACE - filesystem['/'][:size]
space_needed = SPACE_REQUIRED - free_space

puts filesystem.values.map { |dir| dir[:size] }.filter { |dir_size| dir_size > space_needed }.min
