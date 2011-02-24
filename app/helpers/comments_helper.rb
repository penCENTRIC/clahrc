module CommentsHelper
  def link_to_commentable(commentable)
    link_to_content(commentable)
  end
  
  def link_to_destroy_comment(comment)
    unless comment.nil?
      link_to t('comments.destroy'), comment_path(comment), :class => 'destroy comment', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_comment(comment)
    unless comment.nil?
      link_to t('comments.edit'), path_for_edit_comment(comment), :class => 'edit comment'
    end
  end
       
  def commentable_comments_path(commentable)
    send "#{commentable.class.to_s.underscore}_path", commentable, :anchor => 'comments'
  end

  def path_for_edit_comment(comment)
    edit_comment_path(comment)
  end
end
