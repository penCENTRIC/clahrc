module Trackable
  def self.included(base)
    base.class_eval do
      has_many :activities, :as => :trackable
      before_save :track_changes
    
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def track_changes
      @tracked_changes = changes.reject { |key, value| [ 'id', 'created_at', 'updated_at' ].include?(key.to_s) }
    end
    
    def tracked_changes
      @tracked_changes
    end
  end
end
