## Many apps have notions of locations, for example, the GasBuddy app
## has a list of gas stations.  Each location has certain parameters,
## such as name, address, and distance.

class Location
  attr_reader :name, :address, :distance
  attr_writer :name, :address, :distance
  
  def eql?(loc)
    (@name==loc.name) and (@address==loc.address)
  end
  
  def ==(loc)
    eql?(loc)
  end
  
  def initialize(name="",address="",distance=0.0)
    @name = name.strip
    @address = address.strip
    @distance = distance
  end
  
  def hash
    to_s.hash
  end

  def to_s
    "#{name},#{address}"
  end
  
  def to_json(*a)
    {
      "json_class" => self.class.name,
      "name" => @name,
      "address" => @address,
      "distance" => @distance
    }.to_json(*a)
  end
  
  def self.json_create(o)
    new(o["name"], o["address"], o["distance"])
  end
end
