# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vestal_versions}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["laserlemon"]
  s.date = %q{2009-09-05}
  s.description = %q{Keep a DRY history of your ActiveRecord models' changes}
  s.email = %q{steve@laserlemon.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "generators/vestal_versions_migration/templates/migration.rb",
     "generators/vestal_versions_migration/vestal_versions_migration_generator.rb",
     "init.rb",
     "lib/version.rb",
     "lib/vestal_versions.rb",
     "test/between_test.rb",
     "test/changes_test.rb",
     "test/comparable_test.rb",
     "test/creation_test.rb",
     "test/latest_changes_test.rb",
     "test/revert_test.rb",
     "test/schema.rb",
     "test/test_helper.rb",
     "vestal_versions.gemspec"
  ]
  s.homepage = %q{http://github.com/laserlemon/vestal_versions}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{laser-lemon}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Keep a DRY history of your ActiveRecord models' changes}
  s.test_files = [
    "test/between_test.rb",
     "test/changes_test.rb",
     "test/comparable_test.rb",
     "test/creation_test.rb",
     "test/latest_changes_test.rb",
     "test/revert_test.rb",
     "test/schema.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
