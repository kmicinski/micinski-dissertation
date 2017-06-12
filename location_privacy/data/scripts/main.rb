#! /usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'pathname'

require './dataset'
require './data'
require './applist'
require './plotter'

THIS_FILE = Pathname.new(__FILE__).realpath.to_s
HOME = File.dirname(__FILE__) + "/.."

class Array
  # Process each element of an array using a separate process. 
  # @param [Array<T>] An array to process in a mapped fashion
  # @param block A block taking two parameters, the object of the
  # array and an index of the pid
  # @return [Array<Fixnum>] An array of pids (children).
  def process_each
    pids = Array.new
    self.each do |x|
      pids << fork
      if !pids[-1]
        yield x, pids[-1]
        exit
      end
    end
    pids
  end
  
  #Sequential implementation
  # def process_each 
  #   self.each { |x| yield x; sleep 5}
  #   []
  # end
end

# Main data processor: collects, processes, and plots data from files
# given for selected apps
class MainProcessor 
  attr_accessor :plot_set_int, :plot_edit_dist, :plot_add_dist, :build_cache
  
  def initialize
    @plot_set_int = false
    @plot_edit_dist = false
    @plot_add_dist = false
  end

  # Make all plots for an app.  Calculate the metric and vary this
  # over a set of cutoff points (alpha) from `start` to `max`, varying
  # by `inc`
  #
  # @param app The app which should be plotted
  # @param [Fixnum] start The number at which to start plotting
  # @param [Fixnum] max The maximum number of data points
  # @param [Fixnum] inc The increment for each successive plot
  # @param [Symbol] tp The metric to use
  def plot_up_to_max(app,tp)
    max = app::MAX_ALPHA
    start = app::MIN_ALPHA
    inc = app::ALPHA_INC
    alphas = []
    i = start
    while (i <= max)
      alphas << i
      i += inc
    end
    # Paralleize using `fork`, keeping pids in this array
    pids = Array.new
    puts "forking a new process for each alpha value"
    
    # Plot for edit distance
    alphas.process_each do |alpha|
      cl = app.new(HOME+"/"+app::NAME, $cities,  Data::SKEWS, i, tp)
      cl.alpha = alpha
      cl.process()
      puts "done plotting"
      case tp.to_sym
      when :set_int
        ylab = "Set intersection size as % of original set size"
      when :add_dist
        ylab = "Additional distance to destination (km)"
      when :edit_dist
        ylab = "Edit distance"
      end
      plotter = Plotter.new("Location trunction (km)", ylab,
                            Data::APPS_TO_NAMES[cl.name.to_sym],
                            "location")
      
      plotter.range=(0..i)
      cl.plot_medians_across_cities(plotter)
    end.each { |x| Process.wait x }
  end
  
  # Make all the available plots.
  def generate_plots(app)
    # Plot edit distances for varying values of alpha
    puts "spawning separate processes for each metric"
    %w[plot_edit_dist plot_add_dist plot_set_int].process_each{ |x|
      if(instance_variable_get("@#{x}")) then
        puts "Generating plots for #{app}"
        plot_up_to_max(app, x.match(/plot_(.*)/)[1])
      end
    }.each { |x| Process.wait x }
    puts "all metrics done"
  end
  
  # Generate plots for each of the apps given in the options list.
  # 
  # @param [Array<String>] apps The set of apps to process.
  def process(apps)
    apps.each { |app|
      puts "Generating plots and data for #{app}"
      klass = Kernel.const_get(app.capitalize)
      if @build_cache
        raise ArgumentException unless klass
        cl = klass.new(HOME+"/"+klass::NAME, $cities,
                       Data::SKEWS, 0, nil, false).build_cache
      else
        generate_plots(klass)
      end
    }
  end
end

main = MainProcessor.new
apps = []

OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{THIS_FILE}"
  opts.on("--app app", "the test on which to begin") do |x|
    apps = [x]
  end
  opts.on("--build-cache", "build caches of data") do
    main.build_cache = true
  end
  opts.on("--all-apps") do
    apps = ['gasbuddy','restaurant_finder','walmart','tdbank','webmd','hospitals']
  end

  opts.on("--plot metric", "make plots for `metric`") do |x|
    main.instance_variable_set("@plot_#{x.gsub('-','_')}".to_sym, true)
  end
  opts.on("--all-plots", "plot all metrics") do
    main.instance_variables.grep(/plot_/).each { |var| 
      main.instance_variable_set(var, true)
    }
  end
  opts.on_tail("-h", "--help", "show this message") do
    puts opts
    exit
  end
end.parse!

apps.each do |app|
  # Load the set of cities from the dataset
  $cities = Hash.new
  Dir.glob("../#{app}/**/").each { |dirent|
    subdir = dirent.split("/")[-1]
    if !(subdir =~ /([a-z_]+)\z/)
      next
    end
    
    Dir.glob("../#{app}/#{subdir}/**/").each { |s|
      sampdir = s.split("/")[-1]
      if !(sampdir =~ /[a-z]+_([0-9]+)\z/)
        next
      end
      if ($cities[subdir] == nil) then
        $cities[subdir] = Integer($1)
      elsif ($cities[subdir] < Integer($1))
        $cities[subdir] = Integer($1)
      end
    }
  }
  
  main.process([app])
end
