#!/usr/bin/ruby

##
## Generate levenstien distance for any two sets of data.
## 
## ruby compare_files.rb reference_file questioned_file
##

## I took this from..
## I'm not sure what the copyright on this is but I figured if we had
## to release it I'd just write up my own implementation.
## http://www.codecodex.com/wiki/Levenshtein_Distance#Ruby

def distance(s, t)
  m = s.size
  n = t.size
  d = Array.new(m+1) { Array.new(n+1) }
  for i in 0..m
    d[i][0] = i
  end
  for j in 0..n
    d[0][j] = j
  end
  for j in 0...n
    for i in 0...m
      if s[i,1] == t[j,1]
        d[i+1][j+1] = d[i][j]
      else
        d[i+1][j+1] = [d[i  ][j+1] + 1, # deletion
                       d[i+1][j  ] + 1, # insertion
                       d[i  ][j  ] + 1  # substitution
                      ].min
      end
    end
  end
  d[m][n]
end

a = IO.readlines(ARGV[0]).each { |x| x.hash }
b = IO.readlines(ARGV[1]).each { |x| x.hash }

puts "#{ARGV[1].split('/')[-1].split('.')[0]} #{distance(a,b)}"
