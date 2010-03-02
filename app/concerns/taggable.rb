module Taggable
  def self.included(base)
    base.acts_as_taggable_on :tags
    base.attr_accessible :tag_list
  end
end
