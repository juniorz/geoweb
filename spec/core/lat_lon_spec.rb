require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LatLon do
  
  describe :initialize do
  
    before(:all) do
      @lat = -17.4727215168151
      @lon = -40.6738941939658
    end
  
    it "should accept latitude and longitude" do
      @latlon = LatLon.new(@lat, @lon)
      @latlon.lat.should == @lat
      @latlon.lon.should == @lon
    end

    it "should accept an object with :lat and :lon methods" do
      lat_lon_object = double("array input")
      lat_lon_object.stub(:respond_to?).with(any_args()).and_return(false)

      lat_lon_object.should_receive(:respond_to?).with(:lat).and_return(true)
      lat_lon_object.should_receive(:respond_to?).with(:lon).and_return(true)

      lat_lon_object.should_receive(:lat).and_return(@lat)
      lat_lon_object.should_receive(:lon).and_return(@lon)

      @latlon = LatLon.new(lat_lon_object)
      @latlon.lat.should == @lat
      @latlon.lon.should == @lon
    end
    
    it "should accept an object with :x and :y methods" do
      xy_object = double("xy object input")
      xy_object.stub(:respond_to?).with(any_args()).and_return(false)

      xy_object.should_receive(:respond_to?).with(:y).and_return(true)
      xy_object.should_receive(:respond_to?).with(:x).and_return(true)

      xy_object.should_receive(:y).and_return(@lat)
      xy_object.should_receive(:x).and_return(@lon)

      @latlon = LatLon.new(xy_object)
      @latlon.lat.should == @lat
      @latlon.lon.should == @lon
      
    end

    it "should accept an Array with two values" do
      array_or_object = double("array input")
      array_or_object.stub(:respond_to?).with(any_args()).and_return(false)

      array_or_object.should_receive(:respond_to?).with(:to_a).and_return(true)
      array_or_object.should_receive(:to_a).and_return([@lat, @lon])

      @latlon = LatLon.new(array_or_object)
      @latlon.lat.should == @lat
      @latlon.lon.should == @lon
    end
    
    it "should accept a Hash with :lat and :lon keys" do
      hash_or_object = double("hash input")
      hash_or_object.stub(:respond_to?).with(any_args()).and_return(false)

      hash_or_object.should_receive(:respond_to?).with(:to_hash).and_return(true)
      hash_or_object.should_receive(:to_hash).and_return({:lat => @lat, :lon => @lon})

      @latlon = LatLon.new(hash_or_object)
      @latlon.lat.should == @lat
      @latlon.lon.should == @lon
    end

  end  

end
