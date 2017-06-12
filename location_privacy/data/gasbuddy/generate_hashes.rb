#!/usr/bin/ruby
## 
## Generate hashes for processed files...
##

$VERBOSE=true
lines = IO.readlines(ARGV[0])
hashes = []
buf = ""
i = 0

def uniqueify(l)
  new_l = []
  l.each do |x|
    if (not new_l.include?(x))
      new_l.push(x) 
    end
  end
  new_l
end

lines.each do |x|
  if (i == 4)
    ## Hash last three lines
    hashes.push(buf)
    i = 0
    buf = ""
  elsif (i == 3)
    ## Omit the line with the miles on it, as it will vary.
    i += 1
  else
    buf += x.strip
    i += 1
  end
end

uniqueify(hashes).each { |x| puts x }
