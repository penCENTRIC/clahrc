class Activity < ActiveRecord::Base
  attr_accessible :trackable, :user, :group, :controller, :action, :private, :hidden
  
  serialize :changes
  
  include Accessible
  include Commentable
  
  belongs_to :user
  validates_presence_of :user

  belongs_to :group
  
  belongs_to :trackable, :polymorphic => true
  validates_presence_of :trackable
  
  def when
    case (DateTime.now - self.created_at.to_date).to_i
    when 0
      'Today'
    when 1
      'Yesterday'
    when 2..6
      'Past Week'
    when 7..29
      'Past Month'
    when 30..89
      'Past Quarter'
    when 90..364
      'Past Year'
    else
      'Older'
    end
  end
  
  require_dependency 'comment_activity'
  require_dependency 'content_activity'
  require_dependency 'group_activity'
  require_dependency 'relationship_activity'
end
