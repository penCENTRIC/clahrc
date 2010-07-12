class CommunitySubdomain < Subdomain
  class << self
    def matches?(request)
      super && request.subdomain == 'community'
    end
  end
end
