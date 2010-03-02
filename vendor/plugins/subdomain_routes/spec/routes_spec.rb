require 'spec_helper'

describe "ActionController::Routing::Routes" do
  before(:each) do
    map_subdomain(:www, nil) { |www| www.root :controller => "homes", :action => "show" }
  end
  
  it "should know a list of its reserved subdomains" do
    ActionController::Routing::Routes.reserved_subdomains.should == [ "www", "" ]
    ActionController::Routing::Routes.clear!
    ActionController::Routing::Routes.reserved_subdomains.should be_empty
  end
end
