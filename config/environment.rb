# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), 'app_settings')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/concerns #{RAILS_ROOT}/app/observers #{RAILS_ROOT}/app/sweepers )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'mysql'

  config.gem 'compass'
  config.gem 'gravtastic', :source => 'http://gemcutter.org'
  config.gem 'hoptoad_notifier'
  config.gem 'hpricot', :source => 'http://gemcutter.org'
  config.gem 'paged_scopes', :source => 'http://gemcutter.org'
  config.gem 'RedCloth'
  config.gem 'whenever', :lib => false, :source => 'http://gemcutter.org'
  config.gem 'will_paginate', :source => 'http://gemcutter.org'
  config.gem 'thinking-sphinx', :lib => 'thinking_sphinx'

  config.gem 'postmark'
  config.gem 'postmark-rails'
  require    'postmark-rails'
  
  config.gem 'twitter'
  config.gem 'delayed_job', :version => '~> 2.0.0'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = :membership_observer, :message_observer, :message_recipient_observer, :received_message_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.action_mailer.default_url_options = { :hostname => 'community.clahrc.net' }
end

require 'hpricot'
require 'RedCloth'

module ActionView::Helpers::UrlHelper
  def link_to_with_active(name, options = {}, html_options = {}, &block)
    if current_page?(options)
      html_options[:class] = "active #{html_options[:class]}"
    end
    
    link_to_without_active name, options, html_options, &block
  end
  
  alias_method_chain :link_to, :active
end
