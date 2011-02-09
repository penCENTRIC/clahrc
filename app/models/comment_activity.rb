class CommentActivity < Activity
  def comment
    trackable
  end

  def commentable
    comment.commentable if comment
  end

  def describe
    %{
#{comment.user} commented on '#{commentable.title}':

#{comment.body_to_s}

To view the comments, please click the following link:

    #{commentable_comments_url(commentable, :host => 'my.clahrc.net')}
  }
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
