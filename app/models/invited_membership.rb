class InvitedMembership < Membership
  def promote!
    # do nothing
  end
  
  def accept!
    super
    
    update_attribute :type, 'Membership'
  end
  
  def deliver_membership_invitation
    MembershipNotifier.deliver_membership_invitation(self)
  end
end
