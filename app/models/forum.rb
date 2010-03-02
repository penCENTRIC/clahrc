class Forum < Content
  include Orderable
  include Taggable
  include Trackable
  
  delegate :owners, :moderators, :members, :to => :group

  has_many :topics, :as => :parent
end
