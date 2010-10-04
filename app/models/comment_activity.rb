class CommentActivity < Activity
  def comment
    trackable
  end

  def commentable
    comment.commentable if comment
  end

  # TODO : Work out appropriate link
  def describe
    "#{trackable.user} posted a new comment on #{trackable.commentable} - URL tbd"
  end

  # TODO : Some users will get two notifications here
  def prepare_notifications
    notification = { :event => 'reply to followed thread', :status => 'posted', :activity => self }
    comment.root.follows.each { |user| user.process_notification(notification) }
    
    notification = { :event => 'new content in group', :status => 'posted', :activity => self }
    comment.group.members.each { |user| user.process_notification(notification) }
  end
end
