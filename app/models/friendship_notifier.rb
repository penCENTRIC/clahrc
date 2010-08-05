class FriendshipNotifier < ActionMailer::Base
  def friendship_confirmation(friendship)
    subject    "[CLAHRC] Your friendship request"
    recipients friendship.user.email
    from       'no-reply@clahrc.net'
    sent_on    friendship.updated_at
    body       :friendship => friendship
  end

  def friendship_request(friendship)
    subject    "[CLAHRC] Friendship request"
    recipients friendship.relatable.email
    from       'no-reply@clahrc.net'
    sent_on    friendship.updated_at
    body       :friendship => friendship
  end
end
