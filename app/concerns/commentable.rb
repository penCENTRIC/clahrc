module Commentable
  def self.included(base)
    base.attr_accessible :comments_enabled
    base.has_many :comments, :as => :commentable
    base.attr_readonly :comments_count
    
    def comments_disabled?
      !comments_enabled?
    end
  end
end
