module GroupsHelper
  def group_teaser(group, options = {})
    unless group.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => url_for(group)
      
      returning(html = "") do
        doc = nil
        
        if query = options.delete(:query)
          doc = Hpricot(textilize(group.excerpts.description))
        else
          doc = Hpricot(group.description_to_html)
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
    
  def link_to_group(group, options = {})
    unless group.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show group', :url => url_for(group)
      
      if query = options.delete(:query)
        link_to group.excerpts.name, options.delete(:url), options
      else
        link_to group.name_to_s, options.delete(:url), options
      end
    end
  end

  def link_to_destroy_group
    link_to t('groups.destroy'), group_path(group), :class => 'destroy group', :confirm => 'true', :method => :delete
  end
  
  def link_to_edit_group(group)
    unless group.nil?
      link_to t('groups.edit'), edit_group_path(group), :class => 'edit group'
    end
  end
  
  def link_to_groups
    link_to t('groups.index'), groups_path, :class => 'index group'
  end
  
  def link_to_new_group
    link_to t('groups.new'), new_group_path, :class => 'new group'
  end  
  
  def link_to_groups_directory
    link_to t('groups.directory'), directory_groups_path(:directory_id => 1), :class => 'index group'
  end    
end
