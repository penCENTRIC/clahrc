class Friendship < Relationship
  has_one :friendship_request
  after_save :track_and_notify
  
  def accept!
    super

    # Reciprocate the friendship
    begin
      friendship = self.user.friendships.find_or_create_by_user_id(self.relatable_id)
      friendship.update_attribute :confirmed, true
    rescue
      nil
    end
  end
  
  def deliver_friendship_confirmation
    FriendshipNotifier.deliver_friendship_confirmation(self)
  end
  
  def deliver_friendship_request
    FriendshipNotifier.deliver_friendship_request(self)
  end
  
  def track_and_notify
    return unless changed?
    
    action_name = confirmed? ? 'accept' : 'create'
    
    if action_name == 'create'
      FriendshipActivity.create(:trackable => self, :user => relatable, :controller => 'friendships', :action => action_name, :hidden => true)
    elsif action_name == 'accept'
      if activities.any?
        activities.first.update_attributes(:hidden => false, :private => true)
      else
        FriendshipActivity.create(:trackable => self, :user => relatable, :controller => 'friendships', :action => action_name, :private => true)
      end
      
      FriendshipActivity.create(:trackable => self, :user => user, :controller => 'friendships', :action => action_name, :private => true)
    end
  end
end
