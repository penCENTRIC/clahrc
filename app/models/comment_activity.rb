class CommentActivity < Activity
  def comment
    trackable
  end

  def commentable
    comment.commentable if comment
  end

  def describe
    %{
#{user} commented on '#{commentable.title}':

#{comment.body_to_s}

To view the comments, please click the following link:

    #{commentable_comments_url(commentable, :host => 'community.clahrc.net')}
  }
  end

  def commentable_comments_url(commentable, options = {})
    send "#{commentable.class.to_s.underscore}_comments_url", commentable, options
  end
  
  # TODO : Some users will get two notifications here
  def prepare_notifications
    if comment.commentable.respond_to?(:follows)
      notification = { :event => 'reply to followed thread', :status => 'posted', :activity => self }
      comment.commentable.follows.each { |user| user.process_notification(notification) }
    end
    
    notification = { :event => 'new content in group', :status => 'posted', :activity => self }
    comment.group.members.each { |user| user.process_notification(notification, group) unless user == comment.user }
  end
end
