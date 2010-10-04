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
  
  def content_url(content_item)
    case content_item.type
    when 'Page'
      page_url(content_item)
    when 'Post'
      post_url(content_item)
    when 'Forum'
      forum_url(content_item)
    when 'Topic'
      topic_url(content_item)
    when 'WikiPage'
      if content_item.group
        group_wiki_page(content_item.group, content_item)
      else
        member_wiki_page(content_item.owner, content_item)
      end
    end
  end
end