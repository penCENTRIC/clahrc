class ReceivedMessageActivity < Activity
  def received_message
    trackable
  end
  
  def describe
    "#{received_message.sender} sent you a message '#{received_message.subject_to_s}'. Read it at #{my_received_message_path(received_message, :host => 'my.clahrc.net')}"
  end

  def prepare_notifications
    notification = { :event => 'private message', :status => 'posted', :activity => self }
    received_message.recipients.each { |user| user.process_notification(notification) }
  end
end
