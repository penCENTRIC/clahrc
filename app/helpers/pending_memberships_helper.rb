module PendingMembershipsHelper
  def link_to_new_group_membership(group)
    unless group.nil? || group.new_record?
      link_to t('memberships.create'), group_memberships_path(group), :method => :post, :class => 'new membership'
    end
  end
  
  def link_to_pending_group_memberships(group)
    pending_memberships_count = group.pending_memberships.count
    
    if pending_memberships_count == 0
      link_to t('memberships.pending'), pending_group_memberships_path(group), :class => 'pending member'
    else
      link_to t('memberships.pending') + " [#{pending_memberships_count}]", pending_group_memberships_path(group), :class => 'pending member'
    end
  end
end
