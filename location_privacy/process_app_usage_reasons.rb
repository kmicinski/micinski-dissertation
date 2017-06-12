class Hash
  def incordef(k)
    self[k] = self[k]? self[k]+1 : 1
  end
end

vals = {}

IO.readlines("app-location-uses-reasons.txt").each { |line| 
  if (line =~ /\[(.*)\]/)
    $first = nil
    $1.split.map do |x|
      case x.strip
      when /list_/
        vals.incordef('list')
        $first = 'list'
      else
        if x=="ads"
          vals.incordef('ads')
          if $first
            puts "here"
            vals.incordef($first+"ads")
          else
            vals.incordef('onlyads')
          end
        else 
          vals.incordef(x.gsub('_',''))
          $first=x.gsub('_','')
          puts $first
        end
      end
    end
  end
}

File.open('app-location-uses-reasons.tex','w') do |f|
  f.puts '%% Computer generated statistics'
  vals.each do |x,y|
    f.puts "\\newcommand{\\numapps#{x}}{#{y}\\xspace}"
  end
end

puts vals
