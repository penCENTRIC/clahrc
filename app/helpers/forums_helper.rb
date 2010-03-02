module ForumsHelper
  def link_to_destroy_forum(forum)
    unless forum.nil?
      link_to t('forums.destroy'), path_for_forum(forum), :class => 'destroy forum', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_forum(forum)
    unless forum.nil?
      link_to t('forums.edit'), path_for_edit_forum(forum), :class => 'edit forum'
    end
  end
  
  def link_to_new_forum(group = @group)
    link_to t('forums.new'), path_for_new_forum(group), :class => 'new forum'
  end

  def link_to_forum(forum, options = {})
    unless forum.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show forum', :url => path_for_forum(forum)
      
      link_to_content forum, options
    end
  end

  def link_to_forums(group = @group)
    link_to t('forums.index'), path_for_forums(group), :class => 'index forum'
  end
  
  def links_to_forums(group, forums)
    returning(html = "") do
      html << %Q(<ul>)
      
      forums.each do |forum|
        html << %Q(<li>#{link_to_forum(forum)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More groups...', path_for_forums(group)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def forum_teaser(forum, options = {})
    unless forum.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_forum(forum)
    
      content_teaser forum, options
    end
  end
  
  def path_for_edit_forum(forum)
    edit_forum_path(forum)
  end
  
  def path_for_new_forum(group)
    new_group_forum_path(group)
  end

  def path_for_forum(forum)
    forum_path(forum)
  end
  
  def path_for_forums(group)
    group_forums_path(group)
  end
end
