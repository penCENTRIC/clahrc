module ContentsHelper
  def content_teaser(content, options = {})
    unless content.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => url_for(content)
      
      returning(html = "") do
        doc = nil
        
        if query = options.delete(:query)
          doc = Hpricot(textilize(content.excerpts.body))
        else
          doc = Hpricot(content.body_to_html)
        end
        
        if doc.nil?
          # do nothing
        elsif p = (doc/'p').first
          html << p.to_html
        else
          html << doc.to_html
        end
      end
    end
  end
    
  def link_to_content(content, options = {})
    unless content.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => content.class.to_s.underscore, :title => content.title_to_s, :url => url_for(content)
      
      if query = options.delete(:query)
        link_to content.excerpts.title, options.delete(:url), options
      else
        link_to content.title, options.delete(:url), options
      end
    end
  end
end
