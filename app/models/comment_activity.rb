class CommentActivity < Activity
  def comment
    trackable
  end

  def commentable
    comment.commentable if comment
  end

  def describe
    "#{trackable.user} posted a new comment on #{commentable} - #{content_url(commentable)}"
  end

  # TODO : Some users will get two notifications here
  def prepare_notifications
    if comment.commentable.respond_to?(:follows)
      notification = { :event => 'reply to followed thread', :status => 'posted', :activity => self }
      comment.commentable.follows.each { |user| user.process_notification(notification) }
    end
    
    notification = { :event => 'new content in group', :status => 'posted', :activity => self }
    comment.group.members.each { |user| user.process_notification(notification, group) }
  end
end
