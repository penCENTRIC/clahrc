class Post < Content
  include Commentable
  include Taggable
  include Versionable

  define_index do
    indexes :title
    indexes :body
    
    has 'IF(hidden, user_id, NULL)', :as => :owner_id, :type => :integer
    has 'IF(hidden, NULL, IF(private, user_id, 0))', :as => :owner_ids, :type => :integer
    has 'IF(group_id, group_id, 0)', :as => :group_ids, :type => :integer
    
    #set_property :delta => true
  end
  
  named_scope :all_posts, :order => 'updated_at DESC'
end
