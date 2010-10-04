class ContentActivity < Activity
  def content
    trackable
  end
  
  require_dependency 'page_activity'
  
  # TODO : Work out appropriate link
  def describe
    "#{trackable.user} posted new content in #{trackable.group} - URL tbd"
  end

  # TODO : Some users will get two notifications here
  def prepare_notifications
    if content.group
      notification = { :event => 'new content in group', :status => 'posted', :activity => self }
      content.group.members.each { |user| user.process_notification(notification) }
    end
  end
  
end
