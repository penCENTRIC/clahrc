class RelationshipActivity < Activity
  def relationship
    trackable 
  end
  
  require_dependency 'friendship_activity'
  require_dependency 'membership_activity'
end
