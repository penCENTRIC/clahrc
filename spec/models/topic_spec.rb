require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Topic do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end
end
