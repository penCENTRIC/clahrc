class Topic < Content
  include Clipable
  include Commentable
  include Taggable
  
  belongs_to :parent, :polymorphic => true
  
  alias :forum :parent
  
  def comments_disabled?
    !self.comments_enabled?
  end
end
