require './dataset'
require './applist'

def read_file
  kneedata = IO.readlines('knees.txt')
  i = 0
  $knees = []
  
  while i < kneedata.length do
    $knees << 
      [kneedata[i],kneedata[i+1],kneedata[i+2],kneedata[i+3],
       kneedata[i+4]].map { |x| x.strip }
    i = i+5
  end
end

def generate_file(knees,f,method)
  knee_txt = ""
  if knees[0][3].split[0]=="set" then
    metric = "set intersection"
    desc = "the set intersection of the nominal list is 80\\% of the value of the reference list"
  else
    metric = "additional distance"
    desc = "a user would have to travel an additional 1 Km if they went to the top location on the nominal list"
  end
  
  skews = {}
  
  knees.each do |x|
    if !skews[x[2]] then
      skews[x[2]] = {x[0]=>x[1]}
    else
      skews[x[2]][x[0]] = x[1]
    end
  end
    
  skews.keys.each do |app|
    knee_txt = knee_txt ? knee_txt+app : app
    %w{new_york dallas baltimore newhaven redmond decatur}.each do |city|
      #if skews[app][city]==skews[app].values.max || skews[app][city]==skews[app].values.min
       # met = "\\textbf{#{skews[app][city]}}"
      #else
    #end
      met = skews[app][city]
      if (!met || met=="NA")
        met = "N/A"
      else
        met = (Float(skews[app][city])/1000.0).to_s
      end
      knee_txt = knee_txt + " & #{met}"
    end
    knee_txt = knee_txt + " \\\\\n\\hline\n"
  end
  puts knee_txt

  f.puts <<EOF
\\begin{figure*}
 \\small
 \\centering
 \\begin{tabular}{|l||c|c|c|c|c|c|}
 \\hline
 & New York & Dallas & Baltimore & Newhaven & Redmond & Decatur \\\\
 \\hline
 \\hline
 #{knee_txt}
\\end{tabular}
 \\caption{Our apps with the #{metric} metric: the listed value is the maximum error
(from our tests) before which #{desc}.}
 \\label{fig:knee-points-#{metric.split[0]}-#{method}}
\\end{figure*}
EOF
  f.close
end

`rm knees.txt`
puts "Doing additional distance..."
system("ruby main.rb --all-apps --plot add_dist &>/dev/null")
read_file

File.open('../../app-adddist-secondderiv-knees.tex','w') do |f|
  generate_file($knees.select { |x| x[3].split[0]=="additional" && x[4].strip=="finitediff" },f,"finitediff")
end

File.open('../../app-adddist-cutoff-knees.tex','w') do |f|
  generate_file($knees.select { |x| x[3].split[0]=="additional" && x[4].strip=="cutoff"},f,"cutoff")
end

puts "Doing set intersection..."
`rm knees.txt &>/dev/null`

system("ruby main.rb --all-apps --plot set_int &>/dev/null")
read_file

File.open('../../app-setint-secondderiv-knees.tex','w') do |f|
  generate_file($knees.select { |x| x[3].split[0]=="set" && x[4]=="finitediff"},f,"finitediff")
end

File.open('../../app-setint-cutoff-knees.tex','w') do |f|
  generate_file($knees.select { |x| x[3].split[0]=="set" && x[4].strip=="cutoff"},f,"cutoff")
end
