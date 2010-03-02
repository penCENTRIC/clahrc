require 'spec_helper'

describe "subdomain route recognition" do
  before(:each) do
    @request = ActionController::TestRequest.new
    @request.host = "www.example.com"
    @request.request_uri = "/items/2"
  end

  it "should add the host's subdomain to the request environment" do
    request_environment = ActionController::Routing::Routes.extract_request_environment(@request)
    request_environment[:subdomain].should == "www"
  end
  
  it "should add an empty subdomain to the request environment if the host has no subdomain" do
    @request.host = "example.com"
    request_environment = ActionController::Routing::Routes.extract_request_environment(@request)
    request_environment[:subdomain].should == ""
  end
  
  context "for a single specified subdomain" do
    it "should recognise a route if the subdomain matches" do
      map_subdomain(:www) { |www| www.resources :items }
      params = recognize_path(@request)
      params[:controller].should == "www/items"
      params[:action].should == "show"
      params[:id].should == "2"
    end
  
    it "should not recognise a route if the subdomain doesn't match" do
      map_subdomain("admin") { |admin| admin.resources :items }
      lambda { recognize_path(@request) }.should raise_error(ActionController::RoutingError)
    end
  end
  
  context "for a nil or blank subdomain" do
    [ nil, "" ].each do |subdomain|
      it "should recognise a route if there is no subdomain present" do
        map_subdomain(subdomain) { |map| map.resources :items }
        @request.host = "example.com"
        lambda { recognize_path(@request) }.should_not raise_error
      end
    end
  end
  
  context "for multiple specified subdomains" do
    it "should recognise a route if the subdomain matches" do
      map_subdomain(:www, :admin, :name => nil) { |map| map.resources :items }
      lambda { recognize_path(@request) }.should_not raise_error
    end
  
    it "should not recognise a route if the subdomain doesn't match" do
      map_subdomain(:support, :admin, :name => nil) { |map| map.resources :items }
      lambda { recognize_path(@request) }.should raise_error(ActionController::RoutingError)
    end
  end
  
  context "for a :model subdomain" do
    before(:each) do
      map_subdomain(:model => :user) { |user| user.resources :articles }
    end
    
    context "when a nested route is requested" do
      before(:each) do
        @request.host = "mholling.example.com"
        @request.request_uri = "/articles"
      end
      
      it "should match the route if there is a subdomain" do
        lambda { recognize_path(@request) }.should_not raise_error
      end
    
      it "should put the subdomain into the params as :model_id" do
        recognize_path(@request)[:user_id].should == "mholling"
      end
    end
  end
end
