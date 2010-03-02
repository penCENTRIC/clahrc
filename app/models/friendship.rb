class Friendship < Relationship
  has_one :friendship_request
  
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
end
