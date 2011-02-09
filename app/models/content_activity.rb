class ContentActivity < Activity
  def content
    trackable
  end
  
  require_dependency 'page_activity'
  
  def describe
    "#{content.user} posted new content '#{content.title}' - #{content_url(content, :host => 'community.clahrc.net')}"
  end

  def prepare_notifications
    if content.group
      notification = { :event => 'new content in group', :status => 'posted', :activity => self }
      content.group.members.each { |user| user.process_notification(notification, content.group) }
    end
  end
  
end
