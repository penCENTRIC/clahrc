module FriendshipsHelper
  def link_to_friendships(user = current_user)
    unless user.nil?
      link_to t('friendships.index'), friendships_path(user), :class => 'index friendship'
    end
  end
  
  def link_to_new_friendship(user)
    unless user.nil?
      link_to t('friendships.create'), member_friendships_path(user), :class => 'new friendship', :method => :post
    end
  end
  
  def link_to_destroy_friendship(friendship)
    unless friendship.nil?
      link_to t('friendships.destroy'), my_friendship_path(friendship), :class => 'destroy friendship', :method => :delete, :confirm => 'Are you sure?'
    end
  end
  
  def link_to_pending_friendships
    pending_friendships_count = current_user.pending_friendships.count
    
    if pending_friendships_count == 0
      link_to t('friendships.pending'), pending_my_friendships_path, :class => 'pending friendship'
    else
      link_to t('friendships.pending') + " [#{pending_friendships_count}]", pending_my_friendships_path, :class => 'pending friendship'
    end
  end
  
  def link_to_accept_friendship(friendship)
    unless friendship.nil?
      link_to t('friendships.accept'), accept_my_friendship_path(friendship), :method => :put, :class => 'accept friendship'
    end
  end
  
  def link_to_reject_friendship(friendship)
    unless friendship.nil?
      link_to t('friendships.reject'), reject_my_friendship_path(friendship), :method => :delete, :class => 'reject friendship', :confirm => 'Are you sure?'
    end
  end
  
  private
    def friendships_path(user)
      if user.id == current_user.id
        my_friendships_path
      else
        member_friendships_path(:member_id => user.id)
      end
    end
end
