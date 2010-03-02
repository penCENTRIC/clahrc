module SubdomainRoutes
  module Request
    include SplitHost
    
    def subdomain
      subdomain_for_host(host)
    end
  end
end

ActionController::Request.send :include, SubdomainRoutes::Request