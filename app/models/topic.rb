class Topic < Content
  include Clipable
  include Commentable
  include Taggable
  
  define_index do
    indexes :title
    indexes :body
    
    has 'IF(hidden, user_id, NULL)', :as => :owner_id, :type => :integer
    has 'IF(hidden, NULL, IF(private, user_id, 0))', :as => :owner_ids, :type => :integer
    has 'IF(group_id, group_id, 0)', :as => :group_ids, :type => :integer
    
    #set_property :delta => true
  end
  
  belongs_to :parent, :polymorphic => true
  
  alias :forum :parent
  
  def comments_disabled?
    !self.comments_enabled?
  end
end
