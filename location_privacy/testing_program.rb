# A short tool so that I don't have to manually type in everything
# when I'm testing apps.

ADB = '~/Downloads/adt-bundle-mac-x86_64/sdk/platform-tools/adb'

IO.readlines("apps_using_location").each { |apppath|
  apppath.strip.split('/')[-1] =~ /([\w.\d]*)(-\d*)?.apk$/
  app = $1
  puts "testing app: #{app}"
  puts "installing..."
  system(ADB + " install #{apppath}")
  puts "play with the app, write a comment as to why it uses location:"
  reason = gets
  reason.strip!
  next if reason=="no"
  open("app-location-uses-reasons.txt", 'a') do |f|
    f.puts "#{app} #{reason.strip}"
  end
  system(ADB + " uninstall #{app}")
}

