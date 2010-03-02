require 'test/unit/testresult'
require 'spec_helper'

class HomesController < ActionController::Base
end

describe "routing assertions" do
  context "for single-subdomain route" do
    before(:each) do
      map_subdomain :admin, :name => nil do |admin|
        admin.resource :home
      end
      @options = { :controller => "homes", :action => "show", :subdomains => [ "admin" ] }
    end
  
    context "recognition" do
      it "should correctly succeed with a :host option and a subdomain route" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "admin.example.com" }) }
        test.should_not have_errors
        test.should_not fail
      end
    
      it "should correctly fail with a :host option and a subdomain route" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "www.example.com" } ) }
        test.should have_errors
      end
    end
  
    context "generation" do
      it "should correctly succeed with :host and :path options and a subdomain route which changes the subdomain and no subdomain is specified" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "admin.example.com" }, @options, "www.example.com") }
        test.should_not have_errors
        test.should_not fail
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which changes the subdomain and the wrong subdomain is specified" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "admin.example.com" }, @options.merge(:subdomain => "other"), "www.example.com") }
        test.should have_errors
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which changes the subdomain and the correct subdomain is specified" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "admin.example.com" }, @options.merge(:subdomain => "admin"), "www.example.com") }
        test.should_not have_errors
        test.should_not fail
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which doesn't change the subdomain" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "admin.example.com" }, @options, "admin.example.com") }
        test.should_not have_errors
        test.should fail
      end
      
      it "should correctly succeed with a path and a subdomain route which doesn't change the subdomain" do
        test = lambda { assert_generates_with_host("/home", @options, "admin.example.com") }
        test.should_not have_errors
        test.should_not fail
      end
    
      it "should correctly fail with a path and a subdomain route which changes the subdomain" do
        test = lambda { assert_generates_with_host("/home", @options, "www.example.com") }
        test.should_not have_errors
        test.should fail
      end
    end
  end

  context "for multiple-subdomain route" do
    before(:each) do
      @subdomains = [ "admin", "support" ]
      map_subdomain *(@subdomains + [ { :name => nil } ]) do |media|
        media.resource :home
      end
      @options = { :controller => "homes", :action => "show", :subdomains => @subdomains }
    end
  
    context "recognition" do
      it "should correctly succeed with a :host option and a subdomain route" do
        @subdomains.each do |subdomain|
          test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "#{subdomain}.example.com" }) }
          test.should_not have_errors
          test.should_not fail
        end
      end
    
      it "should correctly fail with a :host option and a subdomain route" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "www.example.com" } ) }
        test.should have_errors
      end
    end
  
    context "generation" do
      it "should correctly fail with :host and :path options and a subdomain route which changes the subdomain and no subdomain is specified" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host({ :path => "/home", :host => "#{subdomain}.example.com" }, @options, "www.example.com") }
          test.should have_errors
        end
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which changes the subdomain and the wrong subdomain is specified" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host({ :path => "/home", :host => "#{subdomain}.example.com" }, @options.merge(:subdomain => "other"), "www.example.com") }
          test.should have_errors
        end
      end
      
      it "should correctly succeed with :host and :path options and a subdomain route which changes the subdomain and a correct subdomain is specified" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host({ :path => "/home", :host => "#{subdomain}.example.com" }, @options.merge(:subdomain => subdomain), "www.example.com") }
          test.should_not have_errors
          test.should_not fail
        end
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which doesn't change the subdomain" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host({ :path => "/home", :host => "#{subdomain}.example.com" }, @options, "#{subdomain}.example.com") }
          test.should_not have_errors
          test.should fail
        end
      end
      
      it "should correctly succeed with a path and a subdomain route which doesn't change the subdomain" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host("/home", @options, "#{subdomain}.example.com") }
          test.should_not have_errors
          test.should_not fail
        end
      end
    
      it "should correctly fail with a path and a subdomain route which changes the subdomain" do
        @subdomains.each do |subdomain|
          test = lambda { assert_generates_with_host("/home", @options.merge(:subdomain => subdomain), "www.example.com") }
          test.should_not have_errors
          test.should fail
        end
      end
    end
  end

  context "for model-based subdomain route" do
    before(:each) do
      map_subdomain :model => :city, :namespace => nil do |city|
        city.resource :home
      end
      @options = { :controller => "homes", :action => "show", :subdomains => :city_id, :city_id => "canberra" }
    end
  
    context "recognition" do
      it "should correctly succeed with a :host option and a subdomain route" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "canberra.example.com" }) }
        test.should_not have_errors
        test.should_not fail
      end

      it "should correctly fail with a :host option and a subdomain route for the wrong subdomain" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "boston.example.com" }) }
        test.should_not have_errors
        test.should fail
      end
    
      it "should correctly fail with a :host option and a subdomain route for no subdomain" do
        test = lambda { assert_recognizes_with_host(@options, { :path => "/home", :host => "example.com" }) }
        test.should have_errors
      end
    end
  
    context "generation" do
      it "should correctly succeed with :host and :path options and a subdomain route which changes the subdomain" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "canberra.example.com" }, @options, "boston.example.com") }
        test.should_not have_errors
        test.should_not fail
      end
      
      it "should correctly fail with :host and :path options and a subdomain route which doesn't change the subdomain" do
        test = lambda { assert_generates_with_host({ :path => "/home", :host => "canberra.example.com" }, @options, "canberra.example.com") }
        test.should_not have_errors
        test.should fail
      end
      
      it "should correctly succeed with :host and :path options and a subdomain route which doesn't change the subdomain" do
        test = lambda { assert_generates_with_host("/home", @options, "canberra.example.com") }
        test.should_not have_errors
        test.should_not fail
      end
          
      it "should correctly fail with :host and :path options and a subdomain route which changes the subdomain" do
        test = lambda { assert_generates_with_host("/home", @options, "www.example.com") }
        test.should_not have_errors
        test.should fail
      end
    end
  end
end
