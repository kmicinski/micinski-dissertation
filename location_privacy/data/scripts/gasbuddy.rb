require 'json'

require './series'
require './location'

# Implementation of processing functionality for gasbuddy
#
# For the gasbuddy app, we have a list of locations, given in the
# form of the following:
#
# (bunch of junk..)
# android.widget.TextView: Getty
# android.widget.TextView: 141-50 Union Tpke  & Main 
# android.widget.TextView: Queens, NY
# android.widget.TextView: 0.23 mi
# (more junk..)
#
# So we want to take each of these collections and turn it in a list
# of location objects.

class Gasbuddy < Dataset
  attr_writer :alpha
  attr_reader :median_error, :edit_distance_consideration, :alpha
  
  MIN_ALPHA = 20
  MAX_ALPHA = 20
  ALPHA_INC = 5
  NAME = "gasbuddy"
  APPNAME = "Gasbuddy"
  
  def name; NAME; end
  def self.name; NAME; end
  
  # The file in which to cache the result of the (long) processing
  # operation.
  def cache_file
    "./#{name}_cached"
  end

  # Takes in troyd output and munges it to get raw sets of locations
  #
  # @param [String] data raw data from troyd
  # @return [Array[Location]] list of unique location objects
  def raw_to_location_list(data)
    # Check first to see if there is a cached (serialized) version of
    # the processed information.
    # XXX 
    locations = []
    i = 0
    locations = []
    while (i < data.size)
      if (data[i+3]=~/.*mi\z/) then 
        loc = data[i..i+3]
        parts = []
        loc.each { |x| parts.push(x.split(':')[1].strip) }
        # go from "0.28 mi" to the float .28
        l = Location.new(parts[0],
                         parts[1]+parts[2],
                         Float(parts[3].split[0]))
        locations.push(l)
        i += 3
      else
        i = i+1
      end
      locations.uniq!
    end
    take_initial_segment(locations)
  end
  
  # Chops off the beginning of the list
  # @return The first `@alpha` elements of `lst`
  def take_initial_segment(lst)
    return [] unless lst
    if (@alpha > 0)
      return lst[0..(@alpha-1)]
    else 
      return lst
    end
  end
  
  # The delta distance metric
  def delta_distance_metric(nominal,skew,c,s,sk)
    if (nominal.nil?)
      return nil
    end
    top_nominal = nominal[0]
    #puts "top nominal"
    #puts top_nominal
    top_skew = skew[0]
    #puts top_skew
    # puts nominal
    # puts skew
    # puts "here" 
    # exit
    if (top_skew.nil? || top_nominal.nil?) then return nil end
    top_skew_in_nominal = nominal.select { |x| x.address == top_skew.address }[0]
    if (!top_skew_in_nominal)
    then 
      return nil
    else
      begin
        a = top_skew_in_nominal.distance - top_nominal.distance
      rescue => e
        return nil
      end
    end
    a
  end
  
  # Edit distance between two lists
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
        if s[i] == t[j]
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
  
  # Input: a list of Location objects
  # Output: The edit distance from the reference sample
  # Note that we first chop off the last part of the list.
  def edit_dist_process(city,sample,skew,reference_set,current_set)
    a = distance(reference_set,current_set)
    a
  end

  def set_int_process(city,sample,skew,reference_set,current_set)
    if reference_set
      (reference_set & current_set).size
    else
      puts "error!"
      []
    end
  end
  
  # Additional distance metric
  def additional_dist_process(city,sample,skew,reference_set,current_set)
    puts city +  " " + sample.to_s + " " + skew.to_s + " " +  ((delta_distance_metric(reference_set,current_set,city,sample,skew)).to_s || "0")
    
    delta_distance_metric(reference_set,current_set,city,sample,skew)
  end
  
  # Input: A set of cities, locations, and skews
  # Output: For each city, and each skew, the median error for that
  # skew
  def calculate_median_error
    puts "calculating median error"
    @median_error = Hash.new
    
    @data.keys.each { |city|
      @median_error[city] = Hash.new
      
      # for each skew, calculate the median for each location
      Data::SKEWS.each { |y|
        x = y.to_s
        skews = []
        bad = 0
        zeros = 0
        @data[city].size.times { |sample|
          if !@data[city][sample][x].nil? then
            if @data[city][sample][x]==0
              zeros=zeros+1
            end
            #if zeros < 3
            #end
            skews.push(@data[city][sample][x])
            puts "#{@data[city][sample][x]} #{city} #{sample} #{x}"
          else
            bad = bad+1
            puts "error #{city} #{sample} #{x}"
          end
        }
        puts "bad: #{bad}"
        skews.sort!
        # puts "for city #{city} and error #{x} we get..."
        # puts skews
        begin
          @median_error[city][x] = (skews[skews.length/2]+skews[skews.length/2+1])/2
        rescue => e
          if (Integer(x) < 20000)
            @median_error[city][x] = skews[skews.length/2]
          end
          # Do nothing
        end
        # puts "#{skews[skews.length/2]} #{city} #{x}"
      }
    }
    @median_error
  end
  
  def print_vals
    puts "calculating median error"
    @data.keys.each { |city|
      # for each skew, calculate the median for each location
      Data::SKEWS.each { |x|
        skews = []
        puts "#{city} #{x} @data[city][0][x]"
      }
    }
  end
  
  def check_for_errors(c,sam,skew,ref,cur)
    begin
    if (cur.length == 0) then
      puts "Warning: the test in city #{c}, sample #{sam}, skew #{skew} is corrupted."
      return nil
    else 
      return cur
    end
    rescue => e
      puts "Warning: the test in city #{c}, sample #{sam}, skew #{skew} is corrupted."
      nil
    end
  end

  # Build the cache to be used later
  def build_cache
    p "build"
    process_each_sample(lambda { |c,sam,skew,ref,cur| raw_to_location_list(cur) })
    process_each_sample(lambda { |c,sam,skew,ref,cur| check_for_errors(c,sam,skew,ref,cur)})
    save_data(cache_file)
  end
  
  # Input: a list of raw objects from troyd
  # Output: for each city, and each skew, the median edit distance
  # from the standard distribution
  def process
    puts "processing data keeping #{@alpha}..."
    # First remove the random outliers and pare down to a set of
    # locations
    begin
      open_data(cache_file)
      puts "opened data from cached file"
    rescue
      puts "Could not load cached data, run app with --build-cache first"
      exit
    end
    
    # Next calculate the edit distance for each pair of points and the
    # reference point
    puts "processing each sample.."
    # Different types of metrics we support
    case @method.to_sym
    when :edit_dist
      process_each_sample(lambda { |c,sam,skew,ref,cur| 
                            edit_dist_process(c,sam,skew,conv(take_initial_segment(ref)),conv(take_initial_segment(cur)))})
    when :set_int
      process_each_sample(lambda { |c,sam,skew,ref,cur| 
                            set_int_process(c,sam,skew,conv(take_initial_segment(ref)),conv(take_initial_segment(cur)))})
    when :add_dist
      process_each_sample(lambda { |c,sam,skew,ref,cur|
                            additional_dist_process(c,sam,skew,conv(ref),conv(cur))})
    end
    
    # Calculate the median error for each city and skew value
    puts "calculating median error"
    calculate_median_error()
    @median_error
  end
  
  # XXX: 
  # 
  # I had to define this because `json_create` no longer works with
  # the JSON gem I'm using as of Ruby 2.0.0.  I'll investigate what is
  # wrong here, but for now I'm manually calling the method to do the
  # conversion.
  def conv(l) 
    if l then 
      l.map { |x| Location.json_create(x) }
    else
      nil
    end
  end

  # chop_off_amount is the percentage of the list that should be kept.
  # .5 means we only consider the first half of the lists for edit
  # distance difference.
  def initialize(basedir,cities,trunc_params,
                 keep_amount,method=:edit_dist,
                 use_cache=true)
    super(basedir,cities,trunc_params,!use_cache)
    @alpha = keep_amount
    @method = method
  end
  
  # For an individual city, make a box and whiskers plot for the
  # different sublocations within that city.
  def plot_box_whiskers_for_city(city, plotter)
    
  end
  
  # For an individual city, plot the median point at that city
  def plot_median_for_city(city, plotter)
    plotter.clear_series
    plotter.add_series(Series.new(@median[city],city,city))
    plotter.generate_plot(@basedir+"/median_#{city}",:median)
  end
  
  def plot_medians_across_cities(plotter)
    #puts "median errors"
    plotter.clear_series
    # Add a series for each city
    @median_error.keys.each { |city|
      #puts city
      @median_error[city].each { |x,y|
        #puts "skew: #{x}, value: #{y}"
      }
      plotter.add_series(Series.new("skew","distortion",@median_error[city],city,city))
    }
    # 
    case @method.to_sym
    when :edit_dist
      file = @basedir +"/plots/medians_across_city_#{@alpha}"
    when :add_dist
      file = @basedir +"/plots/medians_across_city_additional_distance"
    when :set_int
      file = @basedir +"/plots/medians_across_city_si_#{@alpha}"
    end
    
    puts @method
    puts "plotting in: " + file
    plotter.generate_plot(file,:multiple)
  end
  
end
