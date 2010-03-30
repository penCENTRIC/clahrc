module WikiPagesHelper
  def link_to_destroy_wiki_page(wiki_page)
    unless wiki_page.nil?
      link_to t('wiki_pages.destroy'), path_for_wiki_page(wiki_page), :class => 'destroy wiki_page', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_wiki_page(wiki_page)
    unless wiki_page.nil?
      link_to t('wiki_pages.edit'), path_for_edit_wiki_page(wiki_page), :class => 'edit wiki_page'
    end
  end
  
  def link_to_new_wiki_page(parent = current_user)
    link_to t('wiki_pages.new'), path_for_new_wiki_page(parent), :class => 'new wiki_page'
  end

  def link_to_wiki_page(wiki_page, options = {})
    unless wiki_page.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show wiki_page', :url => path_for_wiki_page(wiki_page)
      
      link_to_content wiki_page, options
    end
  end

  def link_to_wiki_pages(parent = current_user)
    link_to t('wiki_pages.index'), path_for_wiki_pages(parent), :class => 'index wiki_page'
  end
  
  def links_to_wiki_pages(parent, wiki_pages)
    returning(html = "") do
      html << %Q(<ul>)
      
      wiki_pages.each do |wiki_page|
        html << %Q(<li>#{link_to_wiki_page(wiki_page)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More wiki_pages...', path_for_wiki_pages(parent)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def wiki_page_teaser(wiki_page, options = {})
    unless wiki_page.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_wiki_page(wiki_page)
    
      content_teaser wiki_page, options
    end
  end
  
  def path_for_edit_wiki_page(wiki_page)
    if wiki_page.group_id.nil? && wiki_page.user_id && wiki_page.user_id == current_user.id
      edit_my_wiki_page_path(wiki_page)
    else
      edit_group_wiki_page_path(wiki_page.group_id, wiki_page)
    end
  end
  
  def path_for_new_wiki_page(parent, options = {})
    case parent
    when Group
      new_group_wiki_page_path(parent, options)
    when User
      if parent.id == current_user.id
        new_my_wiki_page_path(options)
      else
        new_member_wiki_page_path(parent, options)
      end
    else
      nil
    end
  end

  def path_for_wiki_page(wiki_page, options = {})
    if wiki_page.group_id.nil? && wiki_page.user_id && wiki_page.user_id == current_user.id
      my_wiki_page_path(wiki_page, options)
    elsif wiki_page.group_id
      group_wiki_page_path(wiki_page.group_id, wiki_page, options)
    else
      member_wiki_page_path(wiki_page.user_id, wiki_page, options)
    end
  end
  
  def path_for_wiki_pages(parent)
    case parent
    when Group
      group_wiki_pages_path(parent)
    when User
      if parent.id == current_user.id
        my_wiki_pages_path
      else
        member_wiki_pages_path(parent)
      end
    else
      nil
    end
  end
end
