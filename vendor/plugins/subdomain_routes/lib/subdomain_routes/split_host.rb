module SubdomainRoutes
  class TooManySubdomains < StandardError
  end

  module SplitHost
    private
    
    def split_host(host)
      raise HostNotSupplied, "No host supplied!" if host.blank?
      raise HostNotSupplied, "Can't set subdomain for an IP address!" if host =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
      parts = host.split('.')
      if Config.domain_length
        domain_parts = [ ]
        Config.domain_length.times { domain_parts.unshift parts.pop }
        if parts.size > 1
          raise TooManySubdomains, "Multiple subdomains found: #{parts.join('.')}. (Have you set SubdomainRoutes::Config.domain_length correctly?)"
        end
        [ parts.pop.to_s, domain_parts.join('.') ]
      else
        [ parts.shift.to_s, parts.join('.') ]
      end
    end
    
    def domain_for_host(host)
      split_host(host).last
    end
    
    def subdomain_for_host(host)
      split_host(host).first
    end
  end
end