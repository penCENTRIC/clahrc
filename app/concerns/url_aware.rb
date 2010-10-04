module UrlAware
  def self.included(base)
    base.cattr_accessor :default_url_options
    base.send(:include, ClassMethods)
    base.send(:include, ActionController::UrlWriter)
  end
  
  module ClassMethods
    def default_url_options(options = {})
      options.merge({:host=>'www.myhostname.com'})
    end
  end
end