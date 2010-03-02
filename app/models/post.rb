class Post < Content
  include Commentable
  include Taggable
  include Versionable

  named_scope :all_posts, :order => 'updated_at DESC'
end
