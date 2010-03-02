module Orderable
  def self.included(base)
    # ActsAsOrderedTree ;-)
    base.acts_as_tree :order => :position
    base.acts_as_list :scope => :parent_id
    base.attr_accessible :position
  end
end
