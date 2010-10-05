class NotificationPreference < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :context, :polymorphic => true
  
  named_scope :for_event, proc { |e| {:conditions => {:event => e} }}
  named_scope :for_context, proc { |c| {:conditions => {:context_id => c.id, :context_type => c.class.to_s} }}
  named_scope :top_level, :conditions => {:context_id => nil}
  named_scope :contextual, :conditions => 'context_id IS NOT NULL'

  cattr_accessor :event_types, :default_notification_type, :available_notification_types
  self.event_types = ['friend request', 'new content in group', 'reply to followed thread', 'private message']
  self.default_notification_type = 'email digest'
  self.available_notification_types = ['None', 'Email Digest', 'Immediate Email', 'Twitter DM']

  class <<self
    def find_by_context(context)
      find_by_context_id_and_context_type(context.id, context.class.to_s)
    end
    
    def build_or_retrieve_top_level_for_user(user)
      current_prefs = user.notification_preferences.top_level.all
      (event_types - current_prefs.collect(&:event)).each do |event_type|
        current_prefs << user.notification_preferences.create(:event => event_type, :notification_type => default_notification_type)
      end
      current_prefs
    end 
  end
    
end
