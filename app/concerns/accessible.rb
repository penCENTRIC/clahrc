module Accessible
  def self.included(base)
    base.attr_accessible :access
    
    base.named_scope :accessible, lambda { |user|
      {
        :conditions => case
        when user.friend_ids.blank? && user.group_ids.blank?
          [ %Q((user_id = :id) OR (private = :false AND hidden = :false AND group_id IS NULL)), { :false => false, :id => user.id, :group_ids => user.group_ids } ]
        when user.friend_ids.blank?
          [ %Q((user_id = :id) OR (private = :false AND hidden = :false AND group_id IS NULL) OR (group_id IN (:group_ids))), { :false => false, :id => user.id, :group_ids => user.group_ids } ]
        when user.group_ids.blank?
          [ %Q((user_id = :id) OR (private = :false OR user_id IN (:friend_ids)) AND hidden = :false AND group_id IS NULL), { :false => false, :id => user.id, :friend_ids => user.friend_ids } ]
        else
          [ %Q((user_id = :id) OR ((private = :false OR user_id IN (:friend_ids)) AND hidden = :false AND group_id IS NULL) OR (group_id IN (:group_ids))), { :false => false, :id => user.id, :friend_ids => user.friend_ids, :group_ids => user.group_ids } ]
        end
      }
    }
    
    def access
      if self.hidden
        :hidden
      elsif self.private
        :private
      else
        :public
      end
    end

    def access=(v)
      case v.to_sym
      when :hidden
        self.hidden = true
        self.private = true
      when :private
        self.hidden = false
        self.private = true
      when :public
        self.hidden = false
        self.private = false
      end
    end

    def public?
      !(self.hidden || self.private)
    end
  end
end