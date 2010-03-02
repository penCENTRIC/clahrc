module SearchHelper
  def link_to_search_contents(query)
    unless query.blank?
      link_to t('contents.search'), url_for(:controller => 'search', :action => 'index', :q => query), :class => 'search'
    end
  end

  def link_to_search_members(query)
    unless query.blank?
      link_to t('members.search'), url_for(:controller => 'search', :action => 'members', :q => query), :class => 'search'
    end
  end

  def link_to_search_groups(query)
    unless query.blank?
      link_to t('groups.search'), url_for(:controller => 'search', :action => 'groups', :q => query), :class => 'search'
    end
  end

  def link_to_search_pages(query)
    unless query.blank?
      link_to t('pages.search'), url_for(:controller => 'search', :action => 'pages', :q => query), :class => 'search'
    end
  end

  def link_to_search_posts(query)
    unless query.blank?
      link_to t('posts.search'), url_for(:controller => 'search', :action => 'posts', :q => query), :class => 'search'
    end
  end

  def link_to_search_forums(query)
    unless query.blank?
      link_to t('forums.search'), url_for(:controller => 'search', :action => 'forums', :q => query), :class => 'search'
    end
  end

  def link_to_search_topics(query)
    unless query.blank?
      link_to t('topics.search'), url_for(:controller => 'search', :action => 'topics', :q => query), :class => 'search'
    end
  end
end
