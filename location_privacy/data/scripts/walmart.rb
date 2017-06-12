require './gasbuddy'

class Walmart < Gasbuddy
  NAME = "walmart"
  
  MIN_ALPHA = 20
  MAX_ALPHA = 20
  ALPHA_INC = 5
  APPNAME = "Walmart"

  def name; NAME; end
  def self.name; NAME; end
  
  def raw_to_location_list(data)
    # Check first to see if there is a cached (serialized) version of
    # the processed information.
    exit
    locations = []
    printf "."
    i = 0
    locations = []
    while (i < data.size)
      if (data[i+6]=~/miles/) then 
        loc = data[i..i+6]
        parts = []
        # This doesn't work if there are `:` in the output
        loc.each { |x| parts.push(x.split(':')[-1].strip) }
        # go from "0.28 mi" to the float .28
        l = Location.new(parts[0], # Name
                         parts[1]+parts[2], # loc
                         Float(parts[5].strip)) # dist
        locations.push(l)
        i += 6
      else
        i = i+1
      end
      locations.uniq!
    end
    take_initial_segment(locations)
  end
end
