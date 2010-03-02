module TopicsHelper
  def link_to_destroy_topic(topic)
    unless topic.nil?
      link_to t('topics.destroy'), path_for_topic(topic), :class => 'destroy topic', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_topic(topic)
    unless topic.nil?
      link_to t('topics.edit'), path_for_edit_topic(topic), :class => 'edit topic'
    end
  end
  
  def link_to_new_topic(forum = @forum)
    link_to t('topics.new'), path_for_new_topic(forum), :class => 'new topic'
  end

  def link_to_topic(topic, options = {})
    unless topic.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show topic', :url => path_for_topic(topic)
      
      link_to_content topic, options
    end
  end

  def link_to_topics(forum = @forum)
    link_to t('topics.index'), path_for_topics(forum), :class => 'index topic'
  end
  
  def links_to_topics(forum, topics)
    returning(html = "") do
      html << %Q(<ul>)
      
      topics.each do |topic|
        html << %Q(<li>#{link_to_topic(topic)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More topics...', path_for_topics(forum)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def topic_teaser(topic, options = {})
    unless topic.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_topic(topic)
    
      content_teaser topic, options
    end
  end
  
  def path_for_edit_topic(topic)
    edit_topic_path(topic)
  end
  
  def path_for_new_topic(forum)
    new_forum_topic_path(forum)
  end

  def path_for_topic(topic)
    topic_path(topic)
  end
  
  def path_for_topics(forum)
    forum_topics_path(forum)
  end
end
