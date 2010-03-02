module PagesHelper
  def link_to_destroy_page(page)
    unless page.nil?
      link_to t('pages.destroy'), path_for_page(page), :class => 'destroy page', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_page(page)
    unless page.nil?
      link_to t('pages.edit'), path_for_edit_page(page), :class => 'edit page'
    end
  end
  
  def link_to_new_page(parent = current_user)
    link_to t('pages.new'), path_for_new_page(parent), :class => 'new page'
  end

  def link_to_page(page, options = {})
    unless page.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show page', :url => path_for_page(page)
      
      link_to_content page, options
    end
  end

  def link_to_pages(parent = current_user)
    link_to t('pages.index'), path_for_pages(parent), :class => 'index page'
  end
  
  def links_to_pages(parent, pages)
    returning(html = "") do
      html << %Q(<ul>)
      
      pages.each do |page|
        html << %Q(<li>#{link_to_page(page)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More pages...', path_for_pages(parent)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def page_teaser(page, options = {})
    unless page.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_page(page)
    
      content_teaser page, options
    end
  end
  
  def path_for_edit_page(page)
    if page.group_id.nil? && page.user_id && page.user_id == current_user.id
      edit_my_page_path(page)
    else
      edit_page_path(page)
    end
  end
  
  def path_for_new_page(parent)
    case parent
    when Group
      new_group_page_path(parent)
    when User
      if parent.id == current_user.id
        new_my_page_path
      else
        new_member_page_path(parent)
      end
    else
      nil
    end
  end

  def path_for_page(page, options = {})
    if page.group_id.nil? && page.user_id && page.user_id == current_user.id
      my_page_path(page, options)
    else
      page_path(page, options)
    end
  end
  
  def path_for_pages(parent)
    case parent
    when Group
      group_pages_path(parent)
    when User
      if parent.id == current_user.id
        my_pages_path
      else
        member_pages_path(parent)
      end
    else
      nil
    end
  end
end
