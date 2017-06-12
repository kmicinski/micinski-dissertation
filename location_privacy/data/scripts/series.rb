## 
## Representation of a single series in a graph.  Graphs can contain
## multiple series of data.  For example, a graph may contain a series
## for data from new york and a series for data from dallas.
##
## In this series we simply have two dimensional data, higher
## diminsional data needs to extend this.

class Series
  attr_reader :name, :title, :data, :xlabel, :ylabel
  attr_writer :name, :title, :data, :xlabel, :ylabel
  
  def initialize(xlab,ylab,data=nil,name="",title="")
    @xlabel = xlab
    @ylabel = ylab
    @data = (data ? data : Hash.new)
    @title = title
    @name = name
  end
    
  def each(proc)
    @data.each { |x,y| proc.call(x,y) }
  end
  
  def add_point(x,y)
    @data[x] = y
  end
  
  def csv_column_set
    [@xlabel,@ylabel]
  end
  
  def to_csv_column_set
    cs = []
    @data.each { |x,y| cs.push([x,y]) }
  end
end
