module Taggable
  def self.included(base)
    base.class_eval do
      acts_as_taggable_on :tags
      attr_accessible :tag_list
      
      define_index "#{base.name.underscore}_taggable" do
        indexes tags(:name), :as => :tag
      end
    end
  end
end
