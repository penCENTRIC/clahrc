class MembershipObserver < ActiveRecord::Observer
  def after_create(membership)
    if membership.relatable.hidden?
      # do nothing
    elsif membership.relatable.private?
      # do nothing
    elsif membership.is_a? InvitedMembership
      # do nothing
    else
      membership.update_attribute :confirmed, true
    end
  end
end
