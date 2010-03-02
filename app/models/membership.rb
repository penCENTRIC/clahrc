class Membership < Relationship
  belongs_to :relatable, :class_name => 'Group'
  
  alias :group :relatable
  
  def promote!
    update_attribute :type, 'Moderatorship'
  end

  def deliver_membership_confirmation
    MembershipNotifier.deliver_membership_confirmation(self)
  end
  
  def deliver_membership_request
    MembershipNotifier.deliver_membership_request(self)
  end

  require_dependency 'invited_membership'
  require_dependency 'moderatorship'  
end
