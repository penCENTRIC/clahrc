module PostsHelper
  def link_to_destroy_post(post)
    unless post.nil?
      link_to t('posts.destroy'), path_for_post(post), :class => 'destroy post', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_post(post)
    unless post.nil?
      link_to t('posts.edit'), path_for_edit_post(post), :class => 'edit post'
    end
  end
  
  def link_to_new_post(parent = current_user)
    link_to t('posts.new'), path_for_new_post(parent), :class => 'new post'
  end

  def link_to_post(post, options = {})
    unless post.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show post', :url => path_for_post(post)
      
      link_to_content post, options
    end
  end

  def link_to_posts(parent = current_user)
    link_to t('posts.index'), path_for_posts(parent), :class => 'index post'
  end
  
  def links_to_posts(parent, posts)
    returning(html = "") do
      html << %Q(<ul>)
      
      posts.each do |post|
        html << %Q(<li>#{link_to_post(post)}</li>)
      end

      html << %Q(<li class='silver'>#{link_to 'More posts...', path_for_posts(parent)}</li>)      
      html << %Q(</ul>)
    end
  end
      
  def post_teaser(post, options = {})
    unless post.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_post(post)
    
      content_teaser post, options
    end
  end
  
  def path_for_edit_post(post)
    edit_my_post_path(post)
  end
  
  def path_for_new_post(parent)
    new_my_post_path
  end

  def path_for_post(post)
    if post.user_id && post.user_id == current_user.id
      my_post_path(post)
    else
      post_path(post)
    end
  end
  
  def path_for_posts(parent)
    if parent.id == current_user.id
      my_posts_path
    else
      member_posts_path(parent)
    end
  end
end
