class Subdomain
  class << self
    def matches?(request)
      request.subdomain.present? && request.subdomain != 'www'
    end
  end
end
