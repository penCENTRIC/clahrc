class Subscription < Relationship
  belongs_to :relatable, :class_name => 'Topic'
  
  named_scope :for_user, proc { |u| {:conditions => {:user_id => u.id }}}
end
