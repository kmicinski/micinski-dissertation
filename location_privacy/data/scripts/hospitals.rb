
require './gasbuddy'

class Hospitals < Gasbuddy
  
  MIN_ALPHA = 20
  MAX_ALPHA = 20
  ALPHA_INC = 5
  NAME = "hospitals"

  def name; NAME; end
  def self.name; NAME; end
  
  # Process an input sample file from TroyD to a set of locations.
  def raw_to_location_list(data)
    i = 0
    locations = []
    while (i < data.size)
      if (data[i]=~/.*mi\z/) then
        begin
          loc = data[i,1] + data[i+3,1]
          parts = []
        rescue
          return nil
        end
        begin
          loc.each { |x| parts.push(x.split(':')[1].strip) }
          # go from "0.28 mi" to the float .28
          l = Location.new(parts[1],
                           parts[1],
                           Float(parts[0].split[0]))
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
