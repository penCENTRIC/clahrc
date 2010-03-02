class MembershipNotifier < ActionMailer::Base
  def membership_confirmation(membership)
    subject    "[CLAHRC] Your membership request"
    recipients membership.user.email
    from       'clahrc@exeter.ac.uk'
    sent_on    membership.updated_at
    body       :membership => membership
  end

  def membership_invitation(invited_membership)
    subject    "[CLAHRC] Membership invitation"
    recipients invited_membership.user.email
    from       'clahrc@exeter.ac.uk'
    sent_on    invited_membership.updated_at
    body       :invited_membership => invited_membership
  end

  def membership_request(membership)
    subject    "[CLAHRC] Membership request"
    recipients membership.relatable.moderators.collect { |m| m.email }
    from       'clahrc@exeter.ac.uk'
    sent_on    membership.updated_at
    body       :membership => membership
  end
end
