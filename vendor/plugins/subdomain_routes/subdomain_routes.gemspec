# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{subdomain_routes}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Hollingworth"]
  s.date = %q{2009-09-05}
  s.description = %q{SubdomainRoutes add subdomain conditions to the Rails routing system. Routes may be restricted to one or many specified subdomains. An URL will be recognised only if the host subdomain matches the subdomain specified in the route. Route generation is also enhanced, so that the subdomain of a generated URL (or path) will be changed if the requested route has a different subdomain to that of the current request. Model-based subdomain routes can also be defined.}
  s.email = %q{mdholling@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = [
    "LICENSE",
    "README.textile",
    "Rakefile",
    "VERSION.yml",
    "lib/subdomain_routes.rb",
    "lib/subdomain_routes/assertions.rb",
    "lib/subdomain_routes/config.rb",
    "lib/subdomain_routes/mapper.rb",
    "lib/subdomain_routes/request.rb",
    "lib/subdomain_routes/resources.rb",
    "lib/subdomain_routes/routes.rb",
    "lib/subdomain_routes/split_host.rb",
    "lib/subdomain_routes/url_writer.rb",
    "lib/subdomain_routes/validations.rb",
    "rails/init.rb",
    "spec/assertions_spec.rb",
    "spec/extraction_spec.rb",
    "spec/mapping_spec.rb",
    "spec/recognition_spec.rb",
    "spec/resources_spec.rb",
    "spec/routes_spec.rb",
    "spec/spec_helper.rb",
    "spec/test_unit_matcher.rb",
    "spec/url_writing_spec.rb",
    "spec/validations_spec.rb"
  ]
  s.homepage = %q{http://github.com/mholling/subdomain_routes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Rails library for incorporating subdomains into route generation and recognition.}
  s.test_files = [
    "spec/assertions_spec.rb",
    "spec/extraction_spec.rb",
    "spec/mapping_spec.rb",
    "spec/recognition_spec.rb",
    "spec/resources_spec.rb",
    "spec/routes_spec.rb",
    "spec/spec_helper.rb",
    "spec/test_unit_matcher.rb",
    "spec/url_writing_spec.rb",
    "spec/validations_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 2.2.1"])
    else
      s.add_dependency(%q<actionpack>, [">= 2.2.1"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 2.2.1"])
  end
end
