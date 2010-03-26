module Lockable
  def self.included(base)
    base.class_eval do
      attr_accessible :locked, :locked_at, :locked_by
      
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def lock(user)
      if unlocked?
        self.update_attributes(:locked => true, :locked_at => Time.now, :locked_by => user.id)
      elsif self.locked_by == user.id
        self.update_attributes(:locked_at => Time.now)
      else
        # can't lock
      end
    end
    
    def unlock
      self.update_attributes(:locked => false)
    end
    
    def unlocked?
      !locked?
    end
  end
end