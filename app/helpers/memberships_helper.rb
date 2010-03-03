module MembershipsHelper
  def link_to_memberships(user = current_user)
    link_to t('groups.index'), memberships_path(user), :class => 'index membership'
  end
  
  def link_to_destroy_membership(membership)
    link_to t('memberships.destroy'), my_memberships_path(membership), :method => :delete, :class => 'destroy membership'
  end
  
  def link_to_group_memberships(group)
    unless group.nil?
      link_to t('memberships.index'), group_memberships_path(group), :class => 'index membership'
    end
  end
  
  def link_to_invited_memberships
    link_to t('memberships.invited'), invited_my_memberships_path, :class => 'index membership'
  end
  
  def link_to_create_group_membership(group)
    unless group.nil? || group.new_record?
      link_to t('memberships.create'), group_memberships_path(group), :method => :post, :class => 'create membership'
    end
  end
    
  def link_to_new_group_membership(group)
    unless group.nil? || group.new_record?
      link_to t('memberships.new'), new_group_membership_path(group), :class => 'new membership'
    end
  end

  def link_to_pending_group_memberships(group)
    count = group.pending_memberships.count

    if count == 0
      link_to t('memberships.pending'), pending_group_memberships_path(group), :class => 'pending membership'
    else
      link_to t('memberships.pending') + " [#{count}]", pending_group_memberships_path(group), :class => 'pending membership'
    end
  end

  def link_to_accept_membership(membership)
    unless membership.nil?
      link_to t('memberships.accept'), accept_group_membership_path(:group_id => membership.group, :id => membership), :class => 'accept membership', :method => :put
    end
  end

  def link_to_promote_membership(membership)
    unless membership.nil?
      link_to t('memberships.promote'), promote_group_membership_path(:group_id => membership.group, :id => membership), :class => 'promote membership', :method => :put
    end
  end
  
  def link_to_reject_membership(membership)
    unless membership.nil?
      link_to t('memberships.reject'), reject_group_membership_path(:group_id => membership.group, :id => membership), :class => 'reject membership', :method => :delete, :confirm => 'Are you sure?'
    end
  end
  
  def members_to_html(members)
    unless members.blank?
      returning(html = "") do
        html << %Q(<h2>Members</h2>)
        
        members.each do |member|
          html << link_to(avatar_tag(member), current_user == member ? my_account_path : member_path(member))
        end
      end
    end
  end

  def memberships_to_html(memberships)
    unless memberships.blank?
      returning(html = "") do
        html << %Q(<h2>Groups</h2>)
        
        memberships.each do |membership|
          html << render(membership)
        end
      end
    end
  end  
  
  def memberships_path(user)
    if user.id == current_user.id
      my_memberships_path
    else
      member_memberships_path(user)
    end
  end
end
