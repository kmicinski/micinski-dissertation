lines=IO.readlines(ARGV[0])

arr = [100,200,300,400,500,600,700,800,900,1000,2000,5000,10000]
line=1

puts "Location,Trial,Skew,Distance"

lines.each { |x|
  i = 0
  x.split.each { |num|
    i += 1
    puts "#{ARGV[1]},#{line},#{arr[i-1]},#{num}"
  }
  line += 1
}
