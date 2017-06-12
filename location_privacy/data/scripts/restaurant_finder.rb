## Implementation of the processing scripts for restaurant finder:
## only need change the way we find lists of points.

require './gasbuddy'

# This class is named in a slightly strange way because of the hacky
# way I generate plots..
class Restaurant_finder < Gasbuddy
  
  NAME = "restaurant_finder"
  
  def self.name; "restaurant_finder"; end
  def name; "restaurant_finder"; end
  
  # input: raw data from troyd
  # output: a list of unique location objects
  def raw_to_location_list(data)
    i = 0
    locations = []
    while (i+3 < data.size)
      if (data[i+3]=~/.*Km\z/) then 
        loc = data[i,1] + data[i+2..i+4]
        parts = []
        begin
          loc.each { |x| parts.push(x.split(':')[1].strip) }
          # go from "0.28 mi" to the float .28
          l = Location.new(parts[0],
                           parts[3],
                           Float(parts[2].split[0]))
          locations.push(l)
        rescue
          i += 1
          next
        end
      end
      i += 1
      locations.uniq!
    end
    take_initial_segment(locations)
  end
  
end
