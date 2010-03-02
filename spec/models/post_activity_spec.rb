require 'spec_helper'

describe PostActivity do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    PostActivity.create!(@valid_attributes)
  end
end
