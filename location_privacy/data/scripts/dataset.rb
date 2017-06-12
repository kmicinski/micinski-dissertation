## Representation of a dataset as it is carried through the processing
## of the program.  For example, each (city,point) pair will have a
## unique dataset representing the data from a single run at that
## instance.

class Dataset
  # @data is a hash of arrays of hashes. 
  # [city][sample][skew] -- 
  #   contains data representing what is being processed
  attr_reader :location, :point, :data
  
  # The reference dataset is the piece of zero data
  REFERENCE_ITEM = 0
  
  def set_value(index, key)
    @store[index] = key
  end
  
  def get_value(index)
    @store[index]
  end

  # Do preprocessing on a line from an input file: when we get raw
  # TroyD output, we will occasionally have lines from `getViews`
  # which shouldn't be there (it makes our other scripts easier), so
  # we just remove them.
  def process_line(ln)
    ln.strip!
    if ln =~ /(.*)\s+\(\d+\)\z/
      $1
    else
      ln
    end
  end
  
  # Load the files from the data directories
  def load_files
    @data = Hash.new
    @cities.keys.each { |city| 
      @data[city] = Array.new(@cities[city])
      (@cities[city]+1).times { |i|
        @data[city][i] = Hash.new
        @trunc_params.each { |x|
          begin
            @data[city][i][x] = IO.readlines(@basedir+"/#{city}/sample_#{i}/#{x}.out")
            @data[city][i][x].map! do |x| process_line x end
          rescue SystemCallError
            File.open('errorout','a') do |f| f.puts(@basedir+"/#{city}/sample_#{i}/#{x}.out") end
            @data[city][i][x] = nil
          end
        }
      }
    }
  end
  
  def initialize(basedir,cities,trunc_params,load_files=true)
    @basedir = basedir
    @cities = cities
    @trunc_params = trunc_params
    if load_files
      load_files()
    end
  end
    
  def clone_data
    newdata = @data.clone
    @data.keys.each { |city|
      newdata[city] = @data[city].clone
      @data[city].size.times { |sample|
        newdata[city][sample] = @data[city][sample].clone
        @data[city][sample].keys.each { |skew|
          newdata[city][sample][skew] = @data[city][sample][skew].clone if @data[city][sample][skew]
        }
      }
    }
    newdata
  end
  
  # Input is a Proc object which has a processor function:
  # proc(city,sample,skew,reference,current)
  def process_each_sample(processor)
    # Make sure we make clones so that we aren't modifying data in
    # place
    newdata = @data.clone
    @data.keys.each { |city|
      newdata[city] = @data[city].clone
      @data[city].size.times { |sample|
        newdata[city][sample] = @data[city][sample].clone
        @data[city][sample].keys.each { |skew|
          if @data[city][sample][skew]
            newdata[city][sample][skew] = @data[city][sample][skew].clone
            ref = @data[city][sample][0] || @data[city][sample][0.to_s]
            cur = @data[city][sample][skew]
            newdata[city][sample][skew] =
              processor.call(city,sample,skew,ref,cur)
          end
        }
      }
    }
    @data = newdata
  end
  
  # Save the data to a file
  # @param [String] The filename which should be written
  def save_data(file)
    File.open(file, 'w').write(JSON.pretty_generate(@data))
  end
  
  # Open data from a file
  # @param [String] The filename which should be written
  def open_data(file)
    @data = JSON.parse(IO.readlines(file).join)
  end
  
  def process
    @data
  end
  
end


