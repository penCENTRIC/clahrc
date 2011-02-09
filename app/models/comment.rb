class Comment < ActiveRecord::Base
  attr_accessible :body
  
  include Destroyable
  include Editable
  include Orderable
  include Trackable
  
  validates_presence_of :body
  
  belongs_to :user
  belongs_to :group
  belongs_to :commentable, :counter_cache => true, :polymorphic => true

  def can_be_destroyed_by?(user)
    self.commentable.can_be_destroyed_by?(user)
  end
  
  def can_be_edited_by?(user)
    if self.group && self.group.moderators.include?(user)
      true
    elsif self.user_id == user.id
      (Time.now - self.created_at) < 30.minutes
    else
      self.commentable.can_be_edited_by?(user)
    end
  end
  
  def helpers
    ActionController::Base.helpers
  end  

  delegate :sanitize, :textilize, :to => :helpers
  
  def body_to_html
    sanitize(textilize(body))
  end
  
  def body_to_s
    Hpricot(body_to_html).inner_text
  end
  
  def body_for_index
    body_to_s
  end
  
  def subject_to_html
    Hpricot(title).inner_text
  end
  
  def subject_for_index
    subject_to_html
  end
end
