require 'spec_helper'

describe "URL writing" do
  { "nil" => nil, "an IP address" => "207.192.69.152" }.each do |host_type, host|
    context "when the host is #{host_type}" do
      it "should raise an error when a subdomain route is requested" do
        map_subdomain(:www) { |www| www.resources :users }
        with_host(host) do
          lambda { www_users_path }.should raise_error(SubdomainRoutes::HostNotSupplied) 
          lambda { url_for(:controller => "users", :action => "index", :subdomains => ["www"]) }.should raise_error(SubdomainRoutes::HostNotSupplied) 
        end
      end
      
      context "and a non-subdomain route is requested" do
        before(:each) do
          ActionController::Routing::Routes.draw { |map| map.resources :users }
        end

        it "should not raise an error when the route is a path" do
          with_host(host) do
            lambda { users_path }.should_not raise_error
            lambda { url_for(:controller => "users", :action => "index", :only_path => true) }.should_not raise_error
          end
        end
      end
    end
  end

  [ [ "single", :admin, "admin.example.com" ],
    [    "nil",    nil,       "example.com" ] ].each do |type, subdomain, host|
    context "when a #{type} subdomain is specified" do
      before(:each) do
        map_subdomain(subdomain, :name => nil) { |map| map.resources :users }
        @url_options = { :controller => "users", :action => "index", :subdomains => [ subdomain.to_s ] }
        @path_options = @url_options.merge(:only_path => true)
      end
  
      it "should not change the host for an URL if the host subdomain matches" do
        with_host(host) do
          users_url.should == "http://#{host}/users" 
          url_for(@url_options).should == "http://#{host}/users"
        end
      end
    
      it "should change the host for an URL if the host subdomain differs" do
        with_host "other.example.com" do
          users_url.should == "http://#{host}/users"
          url_for(@url_options).should == "http://#{host}/users"
        end
      end

      it "should not force the host for a path if the host subdomain matches" do
        with_host(host) do
          users_path.should == "/users" 
          url_for(@path_options).should == "/users" 
        end
      end

      it "should force the host for a path if the host subdomain differs" do
        with_host "other.example.com" do
          users_path.should == "http://#{host}/users"
          url_for(@path_options).should == "http://#{host}/users"
        end
      end
      
      [ [ "port",     { :port     => 8080    }, "http://#{host}:8080/users" ],
        [ "protocol", { :protocol => "https" }, "https://#{host}/users"     ] ].each do |variant, options, url|
        it "should preserve the #{variant} when forcing the host" do
          with_host "other.example.com", options do
            users_path.should == url
            url_for(@path_options).should == url
          end
        end
      end
  
      context "and a subdomain different from the host subdomain is explicitly requested" do
        it "should change the host if the requested subdomain matches" do
          with_host "other.example.com" do
            users_path(:subdomain => subdomain).should == "http://#{host}/users"
            url_for(@path_options.merge(:subdomain => subdomain)).should == "http://#{host}/users"
          end
        end
    
        it "should raise a routing error if the requested subdomain doesn't match" do
          with_host(host) do
            lambda { users_path(:subdomain => :other) }.should raise_error(ActionController::RoutingError)
            lambda { url_for(@path_options.merge(:subdomain => :other)) }.should raise_error(ActionController::RoutingError)
          end
        end
      end
      
      context "and the current host's subdomain is explicitly requested" do
        it "should not force the host for a path if the subdomain matches" do
          with_host(host) do
            users_path(:subdomain => subdomain).should == "/users" 
            url_for(@path_options.merge(:subdomain => subdomain)).should == "/users" 
          end
        end
      end
    end
  end
  
  [ [               "", [ :books, :dvds ], [ "books.example.com", "dvds.example.com" ] ],
    [ " including nil",     [ nil, :www ], [       "example.com",  "www.example.com" ] ] ].each do |qualifier, subdomains, hosts|
    context "when multiple subdomains#{qualifier} are specified" do
      before(:each) do
        args = subdomains + [ :name => nil ]
        map_subdomain(*args) { |map| map.resources :items }
        @url_options = { :controller => "items", :action => "index", :subdomains => subdomains.map(&:to_s) }
        @path_options = @url_options.merge(:only_path => true)
      end
          
      it "should not change the host for an URL if the host subdomain matches" do
        hosts.each do |host|
          with_host(host) do
           items_url.should == "http://#{host}/items" 
           url_for(@url_options).should == "http://#{host}/items" 
          end
        end
      end
  
      it "should not force the host for a path if the host subdomain matches" do
        hosts.each do |host|
          with_host(host) do
            items_path.should == "/items" 
            url_for(@path_options).should == "/items" 
          end
        end
      end
  
      it "should raise a routing error if the host subdomain doesn't match" do
        with_host "other.example.com" do
          lambda {  item_url }.should raise_error(ActionController::RoutingError)
          lambda { item_path }.should raise_error(ActionController::RoutingError)
          lambda {  url_for(@url_options) }.should raise_error(ActionController::RoutingError)
          lambda { url_for(@path_options) }.should raise_error(ActionController::RoutingError)
        end
      end
    
      context "and a subdomain different from the host subdomain is explicitly requested" do
        it "should change the host if the requested subdomain matches" do
          [ [ subdomains.first, hosts.first, hosts.last ],
            [ subdomains.last, hosts.last, hosts.first ] ].each do |subdomain, new_host, old_host|
            with_host(old_host) do
              items_path(:subdomain => subdomain).should == "http://#{new_host}/items"
              url_for(@path_options.merge(:subdomain => subdomain)).should == "http://#{new_host}/items"
            end
          end
        end

        it "should preserve the port when changing the host" do
          [ [ subdomains.first, hosts.first, hosts.last ],
            [ subdomains.last, hosts.last, hosts.first ] ].each do |subdomain, new_host, old_host|
            with_host(old_host, :port => 8080) do
              items_path(:subdomain => subdomain).should == "http://#{new_host}:8080/items"
              url_for(@path_options.merge(:subdomain => subdomain)).should == "http://#{new_host}:8080/items"
            end
          end
        end

        it "should preserve the protocol when changing the host" do
          [ [ subdomains.first, hosts.first, hosts.last ],
            [ subdomains.last, hosts.last, hosts.first ] ].each do |subdomain, new_host, old_host|
            with_host(old_host, :protocol => "https") do
              items_path(:subdomain => subdomain).should == "https://#{new_host}/items"
              url_for(@path_options.merge(:subdomain => subdomain)).should == "https://#{new_host}/items"
            end
          end
        end
          
        it "should raise a routing error if the requested subdomain doesn't match" do
          [ [ hosts.first, hosts.last ],
            [ hosts.last, hosts.first ] ].each do |new_host, old_host|
            with_host(old_host) do
              lambda { items_path(:subdomain => :other) }.should raise_error(ActionController::RoutingError)
              lambda { url_for(@path_options.merge(:subdomain => :other)) }.should raise_error(ActionController::RoutingError)
            end
          end
        end
      end
    end
  end
  
  it "should downcase a supplied subdomain" do
    map_subdomain(:www1, :www2, :name => nil) { |map| map.resources :users }
    [ [ :Www1, "www1" ], [ "Www2", "www2" ] ].each do |mixedcase, lowercase|
      with_host "www.example.com" do
        users_url(:subdomain => mixedcase).should == "http://#{lowercase}.example.com/users"
        url_for(:controller => "users", :action => "index", :subdomains => [ "www1", "www2" ], :subdomain => mixedcase).should == "http://#{lowercase}.example.com/users"
      end
    end
  end

  context "when a :model subdomain is specified" do          
    before(:each) do
      map_subdomain(:model => :city) { |city| city.resources :events }
      class City < ActiveRecord::Base; end
      @boston = City.new
      @boston.stub!(:new_record?).and_return(false)
      @boston.stub!(:to_param).and_return("boston")
      @url_options = { :controller => "city/events", :action => "index", :subdomains => :city_id, :city_id => @boston }
      @path_options = @url_options.merge(:only_path => true)
    end

    it "should not change the host if the object has the same to_param as the current subdomain" do
      with_host "boston.example.com" do
         city_events_url(@boston).should == "http://boston.example.com/events"
        city_events_path(@boston).should == "/events"
            url_for(@url_options).should == "http://boston.example.com/events"
           url_for(@path_options).should == "/events"
      end
    end
    
    it "should force the host if the object has a different to_param from the current subdomain" do
      with_host "example.com" do
         city_events_url(@boston).should == "http://boston.example.com/events"
        city_events_path(@boston).should == "http://boston.example.com/events"
            url_for(@url_options).should == "http://boston.example.com/events"
           url_for(@path_options).should == "http://boston.example.com/events"
      end
    end
    
    [ [ "port",     { :port     => 8080    }, "http://boston.example.com:8080/events" ],
      [ "protocol", { :protocol => "https" }, "https://boston.example.com/events"     ] ].each do |variant, options, url|
      it "should preserve the #{variant} when forcing the host" do
        with_host "example.com", options do
           city_events_url(@boston).should == url
          city_events_path(@boston).should == url
              url_for(@url_options).should == url
             url_for(@path_options).should == url
        end
      end
    end
  
    it "should raise an error if the object to_param is an invalid subdomain" do
      @newyork = City.new
      @newyork.stub!(:new_record?).and_return(false)
      @newyork.stub!(:to_param).and_return("new york")
      with_host "www.example.com" do
        lambda {  city_events_url(@newyork) }.should raise_error(ActionController::RoutingError)
        lambda { city_events_path(@newyork) }.should raise_error(ActionController::RoutingError)
        lambda {  url_for(@url_options.merge(:city_id => @newyork)) }.should raise_error(ActionController::RoutingError)
        lambda { url_for(@path_options.merge(:city_id => @newyork)) }.should raise_error(ActionController::RoutingError)
      end
    end
      
    it "should not allow the subdomain to be manually overridden in a named route" do
      with_host "www.example.com" do
         city_events_url(@boston, :subdomain => :canberra).should == "http://boston.example.com/events"
        city_events_path(@boston, :subdomain => :canberra).should == "http://boston.example.com/events"
      end
    end
    
    it "should raise a routing error if no subdomain object is supplied to the named route" do
      with_host "www.example.com" do
        [ lambda { city_events_url }, lambda { city_event_url("id") } ].each do |lamb|
          lamb.should raise_error(ActionController::RoutingError) { |e| e.message.should include(":city_id") }
        end
      end
    end
  end
end
