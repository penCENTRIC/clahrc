class Page < Content
  include Clipable
  include Commentable
  include Orderable
  include Taggable
  include Versionable
  
  named_scope :all_pages, :order => 'position ASC, updated_at DESC'
end
