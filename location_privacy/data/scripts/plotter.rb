## 
## The three kinds of graphs used in our code:
##  - Median plot lines
##  - Multiple median plot lines
##  - collections of points for box / whiskers
##
## Plots contain sets of series, each series contains a key / values
## store.  For example, we might have a plot that contains a series
## for new york and dallas.
##

require 'csv'

require './series'

class Plotter
  attr_reader :xlabel, :ylabel, :title, :indextitle, :range
  attr_writer :xlabel, :ylabel, :title, :indextitle, :range
  
  def generate_plot(output_file,type)
    case type
    when :median
      # A single median line
    when :multiple
      # Multiple median lines
      csv = generate_csv_file(output_file+".csv")
      generate_plot_file(output_file+".csv",output_file+".jpg",type, output_file+".R")
      # Actually run R to generate the plot...
      puts "generating plot.."
      puts "Rscript medians_across_city.R #{output_file}.csv #{output_file}.jpg \"#{@title}\" \"#{@ylabel}\" \"#{@ylabel.split[0].strip.downcase}\""
      puts `Rscript medians_across_city.R #{output_file}.csv #{output_file}.jpg \"#{@title}\" \"#{@ylabel}\" \"#{@ylabel.split[0].strip.downcase}\"`
      puts "done generating plot.."
    when :boxwhiskers
      # Box and whiskers plot
    end
  end
  
  # Generate a new CSV file from the set of series
  def generate_csv_file(file)
    puts "generating CSV file #{file}"
    CSV.open(file, "w") do |csv|
      csv << get_columns()
      @data.each { |series|
        (series.data.keys.map { |x| Integer(x) }).sort.each { |y|
          x = y.to_s
          # TODO: Find out why this doesn't work with log plots in R
          if (!series.data[x].nil? && Integer(x) > 0)
            csv << [series.title,Integer(x)/1000.0,series.data[x]]
          elsif (Integer(x) == 0) 
            csv << [series.title,0.001,series.data[x]]
          end
        }
      }
    end
  end
  
  def get_columns
    [@indextitle] + @data[0].csv_column_set
  end
  
  def generate_plot_file(csvfile,outfile,type,rfile)
    f = File.open(rfile, 'w')
    cities = 
      %w[new_york baltimore newhaven redmond dallas decatur].map { |x| "\"#{x}\"" }
      .join(',')
    
    case type
    when :multiple
    end
  end
  
  # Merge another plot into this one.  This assumes that we have
  # another plot that we want to merge into this one.  
  def merge_plot(plot)
    plot.keys.each { |key| 
      @data[key] << plot.data[key]
    }
  end

  def add_point(skew,value)
    @data[skew].push(value)
  end
    
  # Across a large set of data, collect the medians and get just
  # those.  For example, within a city, we collect a number of
  # different samples.  What we want to do, ideally, is to take the
  # median of each sample, and plot that.
  def collect_medians
    data = Hash.new
    @data.keys.each { |key|
      nums = @data[key].sort
      data[key] = [nums[nums.length/2]]
    }
  end
  
  def clear_series
    @data = []
  end
  
  def clone(plot)
    @data = plot.data.clone
    @data = plot.data.xlabel
    @data = plot.data.ylabel
    @data = plot.data.title
  end
  
  def initialize(xlabel="", ylabel="", title="",indextitle="", range=0..0)
    @data = []
    @xlabel = xlabel
    @ylabel = ylabel
    @title = title
    @indextitle = indextitle
    @range = range
  end
  
  # Add a new series to this plot
  def add_series(series)
    if (@data[0]) then
      # Require that all column names are identical
      raise "Column names do not match!" unless ((@data[0].xlabel == series.xlabel) && (@data[0].ylabel == series.ylabel))
    end
    @data.push(series)
  end
  
end
