lines = IO.readlines(ARGV[0])
arr = []

lines.each do |line|
  l = []
  line.split.each do |x|
    if x.strip.to_i
      l.push(x.strip.to_i)
    end
  end
  arr.push(l)
end

out = []

arr[0].length.times do |j|
  sorted = []
  arr.length.times do |i|
    sorted.push(arr[i][j])
  end
  sorted.sort!
  out.push(sorted[sorted.length/2])
end

out.each do |x|
  printf ("%d ", x)
end
puts ""
