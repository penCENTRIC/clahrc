class ContentActivity < Activity
  def content
    trackable
  end
  
  require_dependency 'page_activity'
  
  def describe
    "#{trackable.user} posted new content in #{trackable.group} - #{content_url(content, :host => 'community.clahrc.net')}"
  end

  def prepare_notifications
    if content.group
      notification = { :event => 'new content in group', :status => 'posted', :activity => self }
      content.group.members.each { |user| user.process_notification(notification, content.group) }
    end
  end
  
end
