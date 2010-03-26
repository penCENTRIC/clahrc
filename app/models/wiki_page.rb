class WikiPage < Content
  include Clipable
  include Commentable
  include Lockable
  include Taggable
  include Versionable

  before_save :set_permalink, :if => :set_permalink?
  
  def helpers
    ActionController::Base.helpers
  end

  delegate :link_to, :to => :helpers
  
  module TextileRules
    # Rule to markup wiki style links
    def wiki_links(text)
      Rails.logger.debug("wiki_links: matching #{text.inspect}")
      text.gsub! /\[{2}([^\|\]]+)\|?([^\]]+)?\]{2}/ do |match|
        link, text = match[2..-3].split("|")
        
        text ||= link
        link = URI.escape link.to_s.gsub(/\s/, '_')
        
        "<a class='wiki_page show' href=\"#{link}\">#{text}</a>"
      end
    end
  end
  
  RedCloth.send :include, TextileRules
  
  def body_to_html
    RedCloth.new(body.to_s).extend(RedCloth::Extensions).to_html(:wiki_links)
  end
   
  def to_param
    self.permalink
  end
  
  private
    def set_permalink
      self.permalink = URI.escape self.title.to_s.gsub(/\s/, '_')
    end
    
    def set_permalink?
      self.new_record? || self.permalink.blank?
    end
end
