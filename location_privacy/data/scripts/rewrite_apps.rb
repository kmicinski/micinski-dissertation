require 'find'
require 'thread'

paths = []
IO.readlines('../../app-location-uses-reasons-cp.txt').each do |x|
  if x =~ /\[.*list_sorted.*\] (\S+)/ then
    pkg = $1
    puts pkg
    Find.find "../../../../apps/market-2012-04-11/" do |path|
      if path.strip =~ /#{pkg}(-\d*)?.apk\z/
        puts "found #{path}!"
        paths << path 
      end
    end
  end
end

threads = []
paths.each do |x|
  threads << Thread.new do
    puts `../../../../redexer/scripts/cmd.rb --cmd rewrite --perms loc #{x}`
  end
end

threads.each { |x| x.join }

system('mv ../../../../redexer/results/* ../../../../troyd/location_testing/rewritten_location_apks/')
