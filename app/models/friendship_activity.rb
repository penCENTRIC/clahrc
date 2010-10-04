class FriendshipActivity < RelationshipActivity
  def friendship
    trackable
  end
  
  after_save :prepare_notifications
  def prepare_notifications
    notification = { :event => 'friend request', :status => 'accepted', :activity => self }
    user.process_notification(notification)
  end
end
