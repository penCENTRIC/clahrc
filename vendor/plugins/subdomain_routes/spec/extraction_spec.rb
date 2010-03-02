require 'spec_helper'

describe "subdomain extraction" do
  include SubdomainRoutes::SplitHost

  it "should add a subdomain method to requests" do
    request = ActionController::TestRequest.new
    request.host = "admin.example.com"
    request.subdomain.should == "admin"
  end
  
  it "should raise an error if no host is supplied" do
    lambda { split_host(nil) }.should raise_error(SubdomainRoutes::HostNotSupplied)
  end
  
  context "when the domain length is not set" do
    before(:each) do
      SubdomainRoutes::Config.stub!(:domain_length).and_return(nil)
    end
    
    it "should always find a subdomain and a domain" do
               split_host("example.com").should == [ "example", "com" ]
           split_host("www.example.com").should == [ "www", "example.com" ]
      split_host("blah.www.example.com").should == [ "blah", "www.example.com" ]
    end
    
    it "should raise an error if a nil subdomain is mapped" do
      lambda { map_subdomain(nil) }.should raise_error(ArgumentError)
      lambda { map_subdomain(nil, :www) }.should raise_error(ArgumentError)
    end
  end
  
  context "when domain length is set" do
    before(:each) do
      SubdomainRoutes::Config.stub!(:domain_length).and_return(2)
    end        
      
    it "should find the domain" do
      domain_for_host("www.example.com").should == "example.com"
    end

    it "should find the subdomain when it is present" do
      subdomain_for_host("www.example.com").should == "www"
    end

    it "should return an empty string when subdomain is absent" do
      subdomain_for_host("example.com").should == ""
    end
  
    context "and multi-level subdomains are found" do
      before(:each) do
        @host = "blah.www.example.com"
      end
    
      it "should raise an error" do
        lambda { subdomain_for_host(@host) }.should raise_error(SubdomainRoutes::TooManySubdomains)
      end
          
      it "should raise an error when generating URLs" do
        map_subdomain(:admin) { |admin| admin.resources :users }
        with_host(@host) do
          lambda { admin_users_path }.should raise_error(SubdomainRoutes::TooManySubdomains)
        end
      end
    
      it "should raise an error when recognising URLs" do
        request = ActionController::TestRequest.new
        request.host = @host
        lambda { recognize_path(request) }.should raise_error(SubdomainRoutes::TooManySubdomains)
      end
    end
  end
end
