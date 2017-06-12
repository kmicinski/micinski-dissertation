require './gasbuddy'

class Webmd < Gasbuddy
  NAME = "webmd"
  MAX_ALPHA=20
  ALPHA_INC=10
  MIN_ALPHA=20
  APPNAME = "Web MD"
  def name
    "webmd"
  end
  
  def raw_to_location_list(data)
    # Check first to see if there is a cached (serialized) version of
    # the processed information.
    locations = []
    i = 0
    locations = []
    while (i < data.size)
      if (data[i+3]=~/Miles/) then 
        loc = data[i..i+3]
        parts = []
        # This doesn't work if there are `:` in the output
        loc.each { |x| parts.push(x.split(':')[-1].strip) }
        dist = Float(/\s*([\d.]+)Miles/.match(parts[3])[1])
        # go from "0.28 mi" to the float .28
        l = Location.new(parts[0], # Name
                         parts[1]+parts[2], # loc
                         dist) # dist
        locations.push(l)
        i += 3
      else
        i = i+1
      end
      locations.uniq!
    end
    locations = take_initial_segment(locations)
  end
end
