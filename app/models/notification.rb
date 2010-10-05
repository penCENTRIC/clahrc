class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  
  named_scope :for_digest, :conditions => {:for_digest => true}
  named_scope :sent, :conditions => {:sent => true}
  named_scope :unsent, :conditions => ['sent IS NULL OR sent != ?', true]
end
