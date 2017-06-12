# Takes a file of vector data for distance, a configuration file (for
# x axis), and generates CSV files for it.
# format_into_csv.rb input conf location

input = IO.readlines(ARGV[0])
conf = IO.readlines(ARGV[1])

values = input[0].split
config = conf[0].split

values.length.times { |x|
  puts "#{config[x]},#{values[x]},#{ARGV[2]}"
}
