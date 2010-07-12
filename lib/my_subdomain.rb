class MySubdomain < Subdomain
  class << self
    def matches?(request)
      super && request.subdomain == 'my'
    end
  end
end
