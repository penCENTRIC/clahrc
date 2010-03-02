class ReceivedMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  delegate :sender, :recipients, :subject_to_s, :body_to_html, :body_to_s, :read, :to => :message
  
  def read!
    unless self.read?
      update_attribute :read, true
    end
  end
  
  def deliver_received_message_notification
    ReceivedMessageNotifier.deliver_received_message_notification(self)
  end
end
