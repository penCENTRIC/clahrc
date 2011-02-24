class ContentActivity < Activity
  def content
    trackable
  end
  
  require_dependency 'page_activity'
  
  def describe
    "#{user} posted new content '#{content.title}' - #{content_url(content, :host => 'community.clahrc.net')}"
  end

  def prepare_notifications
    if content.group
      notification = { :event => 'new content in group', :status => 'posted', :activity => self }
      content.group.members.each { |u| u.process_notification(notification, content.group) unless u == user }
    end
  end
  
end
