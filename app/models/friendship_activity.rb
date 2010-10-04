class FriendshipActivity < RelationshipActivity
  def friendship
    trackable
  end
  
  after_save :prepare_notifications
  def prepare_notifications
    notification = { :event => 'friend request', :status => 'accepted', :activity => self }
    user.process_notification(notification)
  end
  
  def describe
    if action == 'create'
      "#{trackable.user} requested the pleasure of your friendship. Review and approve the request at #{pending_my_friendships_url(:host => 'my.clahrc.net')}"
    else
      "#{trackable.relatable} accepted your offer of friendship"
    end
  end
end
