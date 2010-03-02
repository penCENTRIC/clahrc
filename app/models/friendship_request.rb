class FriendshipRequest < Message
  has_one :friendship
  
  def subject
    @subject ||= "Friendship request"
  end
  
  def body
    @body ||= render_to_string(:partial => 'friendships/friendship_request', :locals => { :friendship => self.friendship })
  end
end
