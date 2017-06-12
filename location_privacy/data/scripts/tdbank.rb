require './gasbuddy'

class Tdbank < Gasbuddy
  MIN_ALPHA = 20
  MAX_ALPHA = 20
  ALPHA_INC = 5
  
  NAME = "tdbank"
  APPNAME = "TD Bank"
  
  def name; "tdbank"; end;
  def self.name; NAME; end
  
  def raw_to_location_list(data)
    # Check first to see if there is a cached (serialized) version of
    # the processed information.
    locations = []
    printf "."
    i = 0
    locations = []
    while (i < data.size)
      if (data[i+1]=~/mi\z/) then 
        loc = data[i..i+1]
        parts = []
        # This doesn't work if there are `:` in the output
        loc.each { |x| parts.push(x.split(':')[-1].strip) }
        # go from "0.28 mi" to the float .28
        l = Location.new("TD Bank", # Name, none here, there are images I don't extract
                         parts[0], # Location, an address
                         Float(parts[1].split[0])) # dist
        locations.push(l)
        i += 2
      else
        i = i+1
      end
      locations.uniq!
    end
    take_initial_segment(locations)
  end
end
