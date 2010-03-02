module SubdomainRoutes
  module RoutingAssertions        
    include SubdomainRoutes::RewriteSubdomainOptions

    def assert_recognizes_with_host(expected_options, path, extras={}, message=nil)
      # copied from Rails source, with modification to set the the supplied host on the request
      if path.is_a? Hash
        request_method = path[:method]
        host           = path[:host]
        path           = path[:path]
      else
        request_method = nil
        host = nil
      end
      clean_backtrace do
        ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
        request = recognized_request_for_with_host(path, host, request_method)
        
        expected_options = expected_options.clone
        extras.each_key { |key| expected_options.delete key } unless extras.nil?

        expected_options.stringify_keys!
        routing_diff = expected_options.diff(request.path_parameters)
        
        msg = build_message(message, "The recognized options <?> did not match <?>, difference: <?>",
            request.path_parameters, expected_options, expected_options.diff(request.path_parameters))
        assert_block(msg) { request.path_parameters == expected_options }
      end
    end

    def assert_generates_with_host(expected_path, options, host, defaults={}, extras = {}, message=nil)
      if expected_path.is_a? Hash
        expected_host = expected_path[:host]
        expected_path = expected_path[:path]
      else
        expected_host = nil
      end
      rewrite_subdomain_options(options, host)
      if options.delete(:only_path) == false
        generated_host = options.delete(:host)
        msg = expected_host ? 
          build_message(message, "The route for <?> changed the host to <?> but this did not match expected host <?>", options, generated_host, expected_host) :
          build_message(message, "The route for <?> changed the host to <?> but the host was not expected to change", options, generated_host)
        assert_block(msg) { expected_host == generated_host }
      else
        msg = build_message(message, "The route for <?> was expected to change the host to <?> but did not change the host", options, expected_host)
        assert_block(msg) { expected_host == nil }
      end
      assert_generates(expected_path, options, defaults, extras, message)
    end

    private

    def recognized_request_for_with_host(path, host, request_method = nil)
      path = "/#{path}" unless path.first == '/'

      # Assume given controller
      request = ActionController::TestRequest.new
      request.env["REQUEST_METHOD"] = request_method.to_s.upcase if request_method
      request.path = path
      request.host = host if host
      ActionController::Routing::Routes.recognize(request)
      request
    end
  end
end

ActionController::Assertions::RoutingAssertions.send :include, SubdomainRoutes::RoutingAssertions